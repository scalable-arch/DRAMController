`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

module SAL_SCHED
(
    // clock & reset
    input                       clk,
    input                       rst_n,

    // requests from bank controllers
    SCHED_IF.DST                bk_sched_if_arr[`DRAM_BK_CNT],
    SCHED_IF.SRC                sched_if
);

    // Xilinx Vivado simulator does not support indexing interface array
    // using a for loop. So convert interface array into signal arrays
    // to access using a for loop
    wire    [`DRAM_BK_CNT-1:0]  act_req_arr;
    wire    [`DRAM_BK_CNT-1:0]  rd_req_arr;
    wire    [`DRAM_BK_CNT-1:0]  wr_req_arr;
    wire    [`DRAM_BK_CNT-1:0]  pre_req_arr;
    wire    [`DRAM_BK_CNT-1:0]  ref_req_arr;
    wire    dram_ra_t           ra_arr [`DRAM_BK_CNT];
    wire    dram_ca_t           ca_arr [`DRAM_BK_CNT];
    wire    axi_id_t            id_arr [`DRAM_BK_CNT];
    wire    axi_len_t           len_arr [`DRAM_BK_CNT];

    logic   [`DRAM_BK_CNT-1:0]  act_gnt_arr;
    logic   [`DRAM_BK_CNT-1:0]  rd_gnt_arr;
    logic   [`DRAM_BK_CNT-1:0]  wr_gnt_arr;
    logic   [`DRAM_BK_CNT-1:0]  pre_gnt_arr;
    logic   [`DRAM_BK_CNT-1:0]  ref_gnt_arr;

    genvar  geni;
    generate
        for (geni=0; geni<`DRAM_BK_CNT; geni=geni+1) begin
            assign  act_req_arr[geni]       = bk_sched_if_arr[geni].act_req;
            assign  rd_req_arr[geni]        = bk_sched_if_arr[geni].rd_req;
            assign  wr_req_arr[geni]        = bk_sched_if_arr[geni].wr_req;
            assign  pre_req_arr[geni]       = bk_sched_if_arr[geni].pre_req;
            assign  ref_req_arr[geni]       = bk_sched_if_arr[geni].ref_req;
            assign  ra_arr[geni]            = bk_sched_if_arr[geni].ra;
            assign  ca_arr[geni]            = bk_sched_if_arr[geni].ca;
            assign  id_arr[geni]            = bk_sched_if_arr[geni].id;
            assign  len_arr[geni]           = bk_sched_if_arr[geni].len;

            assign  bk_sched_if_arr[geni].act_gnt   = act_gnt_arr[geni];
            assign  bk_sched_if_arr[geni].rd_gnt    = rd_gnt_arr[geni];
            assign  bk_sched_if_arr[geni].wr_gnt    = wr_gnt_arr[geni];
            assign  bk_sched_if_arr[geni].pre_gnt   = pre_gnt_arr[geni];
            assign  bk_sched_if_arr[geni].ref_gnt   = ref_gnt_arr[geni];
        end
    endgenerate

    wire                        is_t_rrd_met,
                                is_t_ccd_met,
                                is_t_rtw_met,
                                is_t_wtr_met;
    always_comb begin
        for (int i=0; i<`DRAM_BK_CNT; i=i+1) begin
            act_gnt_arr[i]                  = 1'b0;
            rd_gnt_arr[i]                   = 1'b0;
            wr_gnt_arr[i]                   = 1'b0;
            pre_gnt_arr[i]                  = 1'b0;
            ref_gnt_arr[i]                  = 1'b0;
        end
        sched_if.act_gnt                = 1'b0;
        sched_if.rd_gnt                 = 1'b0;
        sched_if.wr_gnt                 = 1'b0;
        sched_if.pre_gnt                = 1'b0;
        sched_if.ref_gnt                = 1'b0;
        sched_if.ba                     = 'hx;
        sched_if.ra                     = 'hx;
        sched_if.ca                     = 'hx;
        sched_if.id                     = 'hx;
        sched_if.len                    = 'hx;

        if ((|act_req_arr) & is_t_rrd_met) begin
            for (int i=0; i<`DRAM_BK_CNT; i=i+1) begin
                if (act_req_arr[i]) begin
                    act_gnt_arr[i]                  = 1'b1;
                    sched_if.act_gnt                = 1'b1;
                    sched_if.ba                     = i;
                    sched_if.ra                     = ra_arr[i];
                    break;
                end
            end
        end
        else if ((|rd_req_arr) & is_t_ccd_met & is_t_wtr_met) begin
            for (int i=0; i<`DRAM_BK_CNT; i=i+1) begin
                if (rd_req_arr[i]) begin
                    rd_gnt_arr[i]                   = 1'b1;
                    sched_if.rd_gnt                 = 1'b1;
                    sched_if.ba                     = i;
                    sched_if.ca                     = ca_arr[i];
                    sched_if.id                     = id_arr[i];
                    sched_if.len                    = len_arr[i];
                    break;
                end
            end
        end
        else if ((|wr_req_arr) & is_t_ccd_met & is_t_rtw_met) begin
            for (int i=0; i<`DRAM_BK_CNT; i=i+1) begin
                if (wr_req_arr[i]) begin
                    wr_gnt_arr[i]                   = 1'b1;
                    sched_if.wr_gnt                 = 1'b1;
                    sched_if.ba                     = i;
                    sched_if.ca                     = ca_arr[i];
                    sched_if.id                     = id_arr[i];
                    sched_if.len                    = len_arr[i];
                    break;
                end
            end
        end
        else if (|pre_req_arr) begin
            for (int i=0; i<`DRAM_BK_CNT; i=i+1) begin
                if (pre_req_arr[i]) begin
                    pre_gnt_arr[i]                  = 1'b1;
                    sched_if.pre_gnt                = 1'b1;
                    sched_if.ba                     = i;
                    break;
                end
            end
        end
        else if ((|ref_req_arr) & is_t_rrd_met) begin
            for (int i=0; i<`DRAM_BK_CNT; i=i+1) begin
                if (ref_req_arr[i]) begin
                    ref_gnt_arr[i]                  = 1'b1;
                    sched_if.ref_gnt                = 1'b1;
                    sched_if.ba                     = i;
                    break;
                end
            end
        end
    end

    // inter-bank
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
endmodule // SAL_SCHED
