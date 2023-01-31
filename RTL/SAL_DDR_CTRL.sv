`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

module SAL_DDR_CTRL
(
    // clock & reset
    input                       clk,
    input                       rst_n,

    // APB interface
    APB_IF.SLV                  apb_if,

    // AXI interface
    AXI_A_IF.DST                axi_ar_if,
    AXI_A_IF.DST                axi_aw_if,
    AXI_W_IF.DST                axi_w_if,
    AXI_B_IF.SRC                axi_b_if,
    AXI_R_IF.SRC                axi_r_if,

    // DFI interface
    DFI_CTRL_IF.SRC             dfi_ctrl_if,
    DFI_WR_IF.SRC               dfi_wr_if,
    DFI_RD_IF.DST               dfi_rd_if
);

    // timing parameters
    TIMING_IF                   timing_if();

    // requests to a bank
    REQ_IF                      bk_req_if_arr[`DRAM_BK_CNT](.clk(clk), .rst_n(rst_n));

    // requests to the scheduler
    wire    [`DRAM_BK_CNT-1:0]  act_req_arr;
    wire    [`DRAM_BK_CNT-1:0]  rd_req_arr;
    wire    [`DRAM_BK_CNT-1:0]  wr_req_arr;
    wire    [`DRAM_BK_CNT-1:0]  pre_req_arr;
    wire    [`DRAM_BK_CNT-1:0]  ref_req_arr;
    dram_ra_t                   ra_arr[`DRAM_BK_CNT];
    dram_ca_t                   ca_arr[`DRAM_BK_CNT];
    axi_id_t                    id_arr[`DRAM_BK_CNT];
    axi_len_t                   len_arr[`DRAM_BK_CNT];
    seq_num_t                   seq_num_arr[`DRAM_BK_CNT];
    
    // grants to bank controllers
    wire    [`DRAM_BK_CNT-1:0]  act_gnt_arr;
    wire    [`DRAM_BK_CNT-1:0]  rd_gnt_arr;
    wire    [`DRAM_BK_CNT-1:0]  wr_gnt_arr;
    wire    [`DRAM_BK_CNT-1:0]  pre_gnt_arr;
    wire    [`DRAM_BK_CNT-1:0]  ref_gnt_arr;

    // scheduling output
    SCHED_IF                    sched_if();

    AXI_A_IF                    axi_aw_internal_if (.clk(clk), .rst_n(rst_n));

    // Configurations
    SAL_CFG                     u_cfg
    (
        .clk                    (clk),
        .rst_n                  (rst_n),

        .apb_if                 (apb_if),

        .timing_if              (timing_if)
    );

    SAL_WR_CTRL                 u_wr_ctrl
    (
        .clk                    (clk),
        .rst_n                  (rst_n),

        .timing_if              (timing_if),
        .sched_if               (sched_if),

        .axi_aw_if              (axi_aw_if),
        .axi_w_if               (axi_w_if),
        .axi_b_if               (axi_b_if),

        .axi_aw2_if             (axi_aw_internal_if),
        .dfi_wr_if              (dfi_wr_if)
    );

    SAL_ADDR_DECODER            u_decoder
    (
        .clk                    (clk),
        .rst_n                  (rst_n),

        .axi_ar_if              (axi_ar_if),
        .axi_aw_if              (axi_aw_internal_if),

        .req_if_arr             (bk_req_if_arr)
    );

    genvar geni;

    generate
        for (geni=0; geni<`DRAM_BK_CNT; geni=geni+1) begin  : BK
            SAL_BK_CTRL
            #(
                .BK_ID                  (geni)
            )
            u_bank_ctrl
            (
                .clk                    (clk),
                .rst_n                  (rst_n),

                .timing_if              (timing_if),

                .req_if                 (bk_req_if_arr[geni]),
                .act_req_o              (act_req_arr[geni]),
                .rd_req_o               (rd_req_arr[geni]),
                .wr_req_o               (wr_req_arr[geni]),
                .pre_req_o              (pre_req_arr[geni]),
                .ref_req_o              (ref_req_arr[geni]),
                .ra_o                   (ra_arr[geni]),
                .ca_o                   (ca_arr[geni]),
                .id_o                   (id_arr[geni]),
                .len_o                  (len_arr[geni]),
                .seq_num_o              (seq_num_arr[geni]),

                .act_gnt_i              (act_gnt_arr[geni]),
                .rd_gnt_i               (rd_gnt_arr[geni]),
                .wr_gnt_i               (wr_gnt_arr[geni]),
                .pre_gnt_i              (pre_gnt_arr[geni]),
                .ref_gnt_i              (ref_gnt_arr[geni]),

                .ref_req_i              (1'b0),
                .ref_gnt_o              ()
            );
        end
    endgenerate

    SAL_SCHED                   u_sched
    (
        .clk                    (clk),
        .rst_n                  (rst_n),
        
        .timing_if              (timing_if),

        .act_req_arr            (act_req_arr),
        .rd_req_arr             (rd_req_arr),
        .wr_req_arr             (wr_req_arr),
        .pre_req_arr            (pre_req_arr),
        .ref_req_arr            (ref_req_arr),
        .ra_arr                 (ra_arr),
        .ca_arr                 (ca_arr),
        .id_arr                 (id_arr),
        .len_arr                (len_arr),
        .seq_num_arr            (seq_num_arr),

        .act_gnt_arr            (act_gnt_arr),
        .rd_gnt_arr             (rd_gnt_arr),
        .wr_gnt_arr             (wr_gnt_arr),
        .pre_gnt_arr            (pre_gnt_arr),
        .ref_gnt_arr            (ref_gnt_arr),

        .sched_if               (sched_if)
    );

    SAL_CTRL_ENCODER            u_encoder
    (
        .clk                    (clk),
        .rst_n                  (rst_n),

        .sched_if               (sched_if),
        .dfi_ctrl_if            (dfi_ctrl_if)
    );

    SAL_RD_CTRL                 u_rd_ctrl
    (
        .clk                    (clk),
        .rst_n                  (rst_n),

        .timing_if              (timing_if),
        .sched_if               (sched_if),
        .dfi_rd_if              (dfi_rd_if),
        .axi_r_if               (axi_r_if)
    );

endmodule // SAL_DDR_CTRL
