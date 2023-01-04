`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

module SAL_BK_CTRL
(
    // clock & reset
    input                       clk,
    input                       rst_n,

    // timing parameters
    TIMING_IF.MON               timing_if,

    // request from the address decoder
    BK_REQ_IF.DST               bk_req_if,
    // scheduling interface
    SCHED_IF.SRC                sched_if,

    // per-bank auto-refresh requests
    input   wire                ref_req_i,
    output  logic               ref_gnt_o
);

    localparam                  S_CLOSED    = 1'b0,
                                S_OPEN      = 1'b1;

    // current state
    logic                       state,              state_n;
    // current row address
    logic   [`DRAM_RA_WIDTH-1:0]cur_ra,             cur_ra_n;

    wire                        is_t_rcd_met,
                                is_t_rp_met,
                                is_t_ras_met,
                                is_t_rfc_met,
                                is_t_rtp_met,
                                is_t_wtp_met;
    wire                        is_t_rrd_met,
                                is_t_ccd_met,
                                is_t_rtw_met,
                                is_t_wtr_met;

    always_ff @(posedge clk)
        if (~rst_n) begin
            state                   <= S_CLOSED;
            cur_ra                  <= 'h0;
        end
        else begin
            state                   <= state_n;
            cur_ra                  <= cur_ra_n;
        end

    always_comb begin
        cur_ra_n                    = cur_ra;
        state_n                     = state;

        ref_gnt_o                   = 1'b0;
        bk_req_if.ready             = 1'b0;

        sched_if.act_gnt            = 1'b0;
        sched_if.rd_gnt             = 1'b0;
        sched_if.wr_gnt             = 1'b0;
        sched_if.pre_gnt            = 1'b0;
        sched_if.ref_gnt            = 1'b0;
        sched_if.ba                 = 'h0;  // bank 0
        sched_if.ra                 = 'hx;
        sched_if.ca                 = 'hx;
        sched_if.id                 = 'hx;
        sched_if.len                = 'hx;

        case (state)
            S_CLOSED: begin     // the bank is closed
                if (is_t_rp_met & is_t_rfc_met & is_t_rrd_met) begin
                    if (ref_req_i) begin
                        // AUTO-REFRESH command
                        sched_if.ref_gnt            = 1'b1;
                        ref_gnt_o                   = 1'b1;
                    end
                    else if (bk_req_if.valid) begin    // a new request came
                        // ACTIVATE command
                        sched_if.act_gnt            = 1'b1;
                        sched_if.ra                 = bk_req_if.ra;

                        cur_ra_n                    = bk_req_if.ra;
                        state_n                     = S_OPEN;
                    end
                end
            end
            S_OPEN: begin
                if (bk_req_if.valid) begin
                    if (cur_ra == bk_req_if.ra) begin // bank hit
                        if (bk_req_if.wr) begin
                            // WRITE command
                            if (is_t_rcd_met & is_t_ccd_met & is_t_rtw_met) begin
                                sched_if.wr_gnt             = 1'b1;
                                sched_if.ca                 = bk_req_if.ca;
                                sched_if.id                 = bk_req_if.id;

                                bk_req_if.ready             = 1'b1;
                            end
                        end
                        else begin
                            // READ command
                            if (is_t_rcd_met & is_t_ccd_met & is_t_wtr_met) begin
                                sched_if.rd_gnt             = 1'b1;
                                sched_if.ca                 = bk_req_if.ca;
                                sched_if.id                 = bk_req_if.id;
                                sched_if.len                = bk_req_if.len;

                                bk_req_if.ready             = 1'b1;
                            end
                        end
                    end
                    else begin  // bank miss
                        if (is_t_ras_met & is_t_rtp_met & is_t_wtp_met) begin
                            // PRECHARGE command
                            sched_if.pre_gnt            = 1'b1;

                            state_n                     = S_CLOSED;
                        end
                    end
                end
            end
        endcase
    end

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_RRD_WIDTH)) u_rrd_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.act_gnt),
        .reset_value_i              (timing_if.t_rrd_m1),
        .is_zero_o                  (is_t_rrd_met)
    );

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_CCD_WIDTH)) u_ccd_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.rd_gnt | sched_if.wr_gnt),
        .reset_value_i              (timing_if.t_ccd_m1),
        .is_zero_o                  (is_t_ccd_met)
    );

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_RTW_WIDTH)) u_rtw_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.rd_gnt),
        .reset_value_i              (timing_if.t_rtw_m1),
        .is_zero_o                  (is_t_rtw_met)
    );

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_WTR_WIDTH)) u_wtr_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.wr_gnt),
        .reset_value_i              (timing_if.t_wtr_m1),
        .is_zero_o                  (is_t_wtr_met)
    );

    // per-bank
    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_RCD_WIDTH)) u_rcd_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.act_gnt),
        .reset_value_i              (timing_if.t_rcd_m1),
        .is_zero_o                  (is_t_rcd_met)
    );

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_RP_WIDTH)) u_rp_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.pre_gnt),
        .reset_value_i              (timing_if.t_rp_m1),
        .is_zero_o                  (is_t_rp_met)
    );

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_RAS_WIDTH)) u_ras_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.act_gnt),
        .reset_value_i              (timing_if.t_ras_m1),
        .is_zero_o                  (is_t_ras_met)
    );

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_RFC_WIDTH)) u_rfc_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.ref_gnt),
        .reset_value_i              (timing_if.t_rfc_m1),
        .is_zero_o                  (is_t_rfc_met)
    );

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_RTP_WIDTH)) u_rtp_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.rd_gnt),
        .reset_value_i              (timing_if.t_rtp_m1),
        .is_zero_o                  (is_t_rtp_met)
    );

    SAL_TIMING_CNTR  #(.CNTR_WIDTH(`T_WTP_WIDTH)) u_wtp_cnt
    (
        .clk                        (clk),
        .rst_n                      (rst_n),

        .reset_cmd_i                (sched_if.wr_gnt),
        .reset_value_i              (timing_if.t_wtp_m1),
        .is_zero_o                  (is_t_wtp_met)
    );

endmodule // SAL_BK_CTRL
