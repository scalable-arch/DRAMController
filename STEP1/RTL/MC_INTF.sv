`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

interface TIMING_IF ();
    // intra-bank timing
    logic   [`T_RCD_WIDTH-1:0]  t_rcd_m1;
    logic   [`T_RP_WIDTH-1:0]   t_rp_m1;
    logic   [`T_RAS_WIDTH-1:0]  t_ras_m1;
    logic   [`T_RFC_WIDTH-1:0]  t_rfc_m1;
    logic   [`T_RTP_WIDTH-1:0]  t_rtp_m1;
    logic   [`T_WTP_WIDTH-1:0]  t_wtp_m1;
    // inter-bank timing
    logic   [`T_RRD_WIDTH-1:0]  t_rrd_m1;
    logic   [`T_CCD_WIDTH-1:0]  t_ccd_m1;
    logic   [`T_WTR_WIDTH-1:0]  t_wtr_m1;
    logic   [`T_RTW_WIDTH-1:0]  t_rtw_m1;
    logic   [3:0]               dfi_wren_lat;
    logic   [3:0]               dfi_rden_lat;

    // synthesizable, for design
    modport SRC (
        output                  t_rcd_m1, t_rp_m1, t_ras_m1, t_rfc_m1, t_rtp_m1, t_wtp_m1,
                                t_rrd_m1, t_ccd_m1, t_wtr_m1, t_rtw_m1, dfi_wren_lat, dfi_rden_lat
    );
    modport MON (
        input                   t_rcd_m1, t_rp_m1, t_ras_m1, t_rfc_m1, t_rtp_m1, t_wtp_m1,
                                t_rrd_m1, t_ccd_m1, t_wtr_m1, t_rtw_m1, dfi_wren_lat, dfi_rden_lat
    );
endinterface

interface BK_REQ_IF ();
    logic                       wr;
    logic                       valid;
    logic                       ready;
    logic   [`AXI_ID_WIDTH-1:0] id;
    logic   [`DRAM_RA_WIDTH-1:0]ra;
    logic   [`DRAM_CA_WIDTH-1:0]ca;
    logic   [`AXI_LEN_WIDTH-1:0]      len;

    // synthesizable, for design
    modport SRC (
        output                  wr, valid, id, ra, ca, len,
        input                   ready
    );
    modport DST (
        input                   wr, valid, id, ra, ca, len,
        output                  ready
    );
endinterface

interface SCHED_IF ();
    logic                       act_req;
    logic                       rd_req;
    logic                       wr_req;
    logic                       pre_req;
    logic                       ref_req;
    logic                       act_gnt;
    logic                       rd_gnt;
    logic                       wr_gnt;
    logic                       pre_gnt;
    logic                       ref_gnt;
    logic   [`DRAM_BA_WIDTH-1:0]ba;
    logic   [`DRAM_RA_WIDTH-1:0]ra;
    logic   [`DRAM_CA_WIDTH-1:0]ca;
    logic   [`AXI_ID_WIDTH-1:0] id;
    logic   [`AXI_LEN_WIDTH-1:0]len;

    // synthesizable, for design
    modport SRC (
        output                  act_req, rd_req, wr_req, pre_req, ref_req, ba, ra, ca, id, len,
        input                   act_gnt, rd_gnt, wr_gnt, pre_gnt, ref_gnt
    );
    modport DST (
        input                   act_req, rd_req, wr_req, pre_req, ref_req, ba, ra, ca, id, len,
        output                  act_gnt, rd_gnt, wr_gnt, pre_gnt, ref_gnt
    );
    modport MON (
        input                   act_req, rd_req, wr_req, pre_req, ref_req, ba, ra, ca, id, len,
        input                   act_gnt, rd_gnt, wr_gnt, pre_gnt, ref_gnt
    );
endinterface

