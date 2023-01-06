`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

// For clocking block (verification part)
// sample -0.1ns before a posedge
`define ISAMPLE_TIME        0.1
// drive 0.1ns after a posedge
`define OSAMPLE_TIME        0.1

interface AXI_IF
(
    input                       clk,
    input                       rst_n
);
    // AW channel
    logic                       awvalid;
    logic                       awready;
    axi_id_t                    awid;
    axi_addr_t                  awaddr;
    axi_len_t                   awlen;
    axi_size_t                  awsize;
    axi_burst_t                 awburst;

    // W channel
    logic                       wvalid;
    logic                       wready;
    axi_id_t                    wid;
    axi_data_t                  wdata;
    axi_strb_t                  wstrb;
    logic                       wlast;

    // B channel
    logic                       bvalid;
    logic                       bready;
    axi_id_t                    bid;
    axi_resp_t                  bresp;

    // AR channel
    logic                       arvalid;
    logic                       arready;
    axi_id_t                    arid;
    axi_addr_t                  araddr;
    axi_len_t                   arlen;
    axi_size_t                  arsize;
    axi_burst_t                 arburst;

    // R channel
    logic                       rvalid;
    logic                       rready;
    axi_id_t                    rid;
    axi_data_t                  rdata;
    axi_resp_t                  rresp;
    logic                       rlast;

    //----------------------------------------------------------
    // synthesizable, for design
    //----------------------------------------------------------
    // master interface
    modport                     MST (
        // AW
        output                      awvalid, awid, awaddr, awlen, awsize, awburst,
        input                       awready,
        // W
        output                      wvalid, wid, wdata, wstrb, wlast,
        input                       wready,
        // B
        input                       bvalid, bid, bresp,
        output                      bready,
        // AR
        output                      arvalid, arid, araddr, arlen, arsize, arburst,
        input                       arready,
        // R
        input                       rvalid, rid, rdata, rresp, rlast,
        output                      rready
    );

    modport                     MST_AW (
        output                      awvalid, awid, awaddr, awlen, awsize, awburst,
        input                       awready
    );

    modport                     MST_W (
        output                      wvalid, wid, wdata, wstrb, wlast,
        input                       wready
    );

    modport                     MST_B (
        input                       bvalid, bid, bresp,
        output                      bready
    );

    modport                     MST_AR (
        output                      arvalid, arid, araddr, arlen, arsize, arburst,
        input                       arready
    );

    modport                     MST_R (
        input                       rvalid, rid, rdata, rresp, rlast,
        output                      rready
    );

    //----------------------------------------------------------
    // slave interface
    modport                     SLV (
        // AW
        input                       awvalid, awid, awaddr, awlen, awsize, awburst,
        output                      awready,
        // W
        input                       wvalid, wid, wdata, wstrb, wlast,
        output                      wready,
        // B
        output                      bvalid, bid, bresp,
        input                       bready,
        // AR
        input                       arvalid, arid, araddr, arlen, arsize, arburst,
        output                      arready,
        // R
        output                      rvalid, rid, rdata, rresp, rlast,
        input                       rready
    );

    modport                     SLV_AW (
        input                       awvalid, awid, awaddr, awlen, awsize, awburst,
        output                      awready
    );

    modport                     SLV_W (
        input                       wvalid, wid, wdata, wstrb, wlast,
        output                      wready
    );

    modport                     SLV_B (
        output                      bvalid, bid, bresp,
        input                       bready
    );

    modport                     SLV_AR (
        input                       arvalid, arid, araddr, arlen, arsize, arburst,
        output                      arready
    );

    modport                     SLV_R (
        output                      rvalid, rid, rdata, rresp, rlast,
        input                       rready
    );

    //----------------------------------------------------------
    // monitor interface
    modport                     MON (
        // AW
        input                       awvalid, awid, awaddr, awlen, awsize, awburst,
        input                       awready,
        // W
        input                       wvalid, wid, wdata, wstrb, wlast,
        input                       wready,
        // B
        input                       bvalid, bid, bresp,
        input                       bready,
        // AR
        input                       arvalid, arid, araddr, arlen, arsize, arburst,
        input                       arready,
        // R
        input                       rvalid, rid, rdata, rresp, rlast,
        input                       rready
    );

    modport                     MON_AW (
        input                       awvalid, awid, awaddr, awlen, awsize, awburst,
        input                       awready
    );

    modport                     MON_W (
        input                       wvalid, wid, wdata, wstrb, wlast,
        input                       wready
    );

    modport                     MON_B (
        input                       bvalid, bid, bresp,
        input                       bready
    );

    modport                     MON_AR (
        input                       arvalid, arid, araddr, arlen, arsize, arburst,
        input                       arready
    );

    modport                     MON_R (
        input                       rvalid, rid, rdata, rresp, rlast,
        input                       rready
    );


    //----------------------------------------------------------
    // for verification only
    // : the following lines are not synthesized
    //----------------------------------------------------------
    // synthesis translate_off

    //----------------------------------------------------------
    // for clocking block
    // master clocking block
    clocking MST_AW_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        output                      awvalid, awid, awaddr, awlen, awsize, awburst;
        input                       awready;
    endclocking

    clocking MST_W_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        output                      wvalid, wid, wdata, wstrb, wlast;
        input                       wready;
    endclocking

    clocking MST_B_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        input                       bvalid, bid, bresp;
        output                      bready;
    endclocking

    clocking MST_AR_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        output                      arvalid, arid, araddr, arlen, arsize, arburst;
        input                       arready;
    endclocking

    clocking MST_R_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        input                       rvalid, rid, rdata, rresp, rlast;
        output                      rready;
    endclocking

    // slave clocking block
    clocking SLV_AW_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        input                       awvalid, awid, awaddr, awlen, awsize, awburst;
        output                      awready;
    endclocking

    clocking SLV_W_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        input                       wvalid, wid, wdata, wstrb, wlast;
        output                      wready;
    endclocking

    clocking SLV_B_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        output                      bvalid, bid, bresp;
        input                       bready;
    endclocking

    clocking SLV_AR_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        input                       arvalid, arid, araddr, arlen, arsize, arburst;
        output                      arready;
    endclocking

    clocking SLV_R_CB @(posedge clk);
        default input #`ISAMPLE_TIME output #`OSAMPLE_TIME;

        output                      rvalid, rid, rdata, rresp, rlast;
        input                       rready;
    endclocking

    // modports for test benches
    modport MST_AW_TB   (clocking MST_AW_CB,    input clk, rst_n);
    modport MST_W_TB    (clocking MST_W_CB,     input clk, rst_n);
    modport MST_B_TB    (clocking MST_B_CB,     input clk, rst_n);
    modport MST_AR_TB   (clocking MST_AR_CB,    input clk, rst_n);
    modport MST_R_TB    (clocking MST_R_CB,     input clk, rst_n);
    modport SLV_AW_TB   (clocking SLV_AW_CB,    input clk, rst_n);
    modport SLV_W_TB    (clocking SLV_W_CB,     input clk, rst_n);
    modport SLV_B_TB    (clocking SLV_B_CB,     input clk, rst_n);
    modport SLV_AR_TB   (clocking SLV_AR_CB,    input clk, rst_n);
    modport SLV_R_TB    (clocking SLV_R_CB,     input clk, rst_n);

    // tasks used for verfication (master side)
    task automatic mst_init();
        awvalid                     = 1'b0;
        awid                        = 'hx;
        awaddr                      = 'hx;
        awlen                       = 'hx;
        awsize                      = 'hx;
        awburst                     = 'hx;

        wvalid                      = 1'b0;
        wid                         = 'hx;
        wdata                       = 'hx;
        wstrb                       = 'hx;
        wlast                       = 'hx;

        bready                      = 1'b0;

        arvalid                     = 1'b0;
        arid                        = 'hx;
        araddr                      = 'hx;
        arlen                       = 'hx;
        arsize                      = 'hx;
        arburst                     = 'hx;

        rready                      = 1'b0;
    endtask

    task automatic aw_send (
        input   axi_id_t            id,
        input   axi_addr_t          addr,
        input   axi_len_t           len,
        input   axi_size_t          size,
        input   axi_burst_t         burst
    );
        MST_AW_CB.awvalid           <= 1'b1;
        MST_AW_CB.awid              <= id;
        MST_AW_CB.awaddr            <= addr;
        MST_AW_CB.awlen             <= len;
        MST_AW_CB.awsize            <= size;
        MST_AW_CB.awburst           <= burst;
        @(posedge clk);
        while (awready!=1'b1) begin
            @(posedge clk);
        end
        MST_AW_CB.awvalid           <= 1'b0;
        MST_AW_CB.awid              <= 'hx;
        MST_AW_CB.awaddr            <= 'hx;
        MST_AW_CB.awlen             <= 'hx;
        MST_AW_CB.awsize            <= 'hx;
        MST_AW_CB.awburst           <= 'hx;
    endtask

    task automatic w_send (
        input   axi_id_t            id,
        input   axi_data_t          data,
        input   axi_strb_t          strb,
        input                       last
    );
        MST_W_CB.wvalid             <= 1'b1;
        MST_W_CB.wid                <= id;
        MST_W_CB.wdata              <= data;
        MST_W_CB.wstrb              <= strb;
        MST_W_CB.wlast              <= last;
        @(posedge clk);
        while (wready!=1'b1) begin
            @(posedge clk);
        end
        MST_W_CB.wvalid             <= 1'b0;
        MST_W_CB.wid                <= 'hx;
        MST_W_CB.wdata              <= 'hx;
        MST_W_CB.wstrb              <= 'hx;
        MST_W_CB.wlast              <= 'hx;
    endtask

    task automatic b_recv (
        output  axi_id_t            id,
        output  axi_resp_t          resp
    );
        MST_B_CB.bready             <= 1'b1;
        @(posedge clk);
        while (bvalid!=1'b1) begin
            @(posedge clk);
        end
        id                          = bid;
        resp                        = bresp;
        MST_B_CB.bready             <= 1'b0;
    endtask

    task automatic ar_send (
        input   axi_id_t            id,
        input   axi_addr_t          addr,
        input   axi_len_t           len,
        input   axi_size_t          size,
        input   axi_burst_t         burst
    );
        MST_AR_CB.arvalid           <= 1'b1;
        MST_AR_CB.arid              <= id;
        MST_AR_CB.araddr            <= addr;
        MST_AR_CB.arlen             <= len;
        MST_AR_CB.arsize            <= size;
        MST_AR_CB.arburst           <= burst;
        @(posedge clk);
        while (arready!=1'b1) begin
            @(posedge clk);
        end
        MST_AR_CB.arvalid           <= 1'b0;
        MST_AR_CB.arid              <= 'hx;
        MST_AR_CB.araddr            <= 'hx;
        MST_AR_CB.arlen             <= 'hx;
        MST_AR_CB.arsize            <= 'hx;
        MST_AR_CB.arburst           <= 'hx;
    endtask

    task automatic r_recv (
        output  axi_id_t            id,
        output  axi_data_t          data,
        output  axi_resp_t          resp,
        output                      last
    );
        MST_R_CB.rready             <= 1'b1;
        @(posedge clk);
        while (rvalid!=1'b1) begin
            @(posedge clk);
        end
        id                          = rid;
        data                        = rdata;
        resp                        = rresp;
        last                        = rlast;
        MST_R_CB.rready             <= 1'b0;
    endtask

    // tasks used for verfication (slave side)
    task automatic slv_init();
        awready                     = 1'b0;

        wready                      = 1'b0;

        bvalid                      = 1'b0;
        bid                         = 'hx;
        bresp                       = 'hx;

        arready                     = 1'b0;

        rvalid                      = 1'b0;
        rid                         = 'hx;
        rdata                       = 'hx;
        rresp                       = 'hx;
        rlast                       = 'hx;
    endtask
    // synthesis translate_on

endinterface

interface APB_IF (
    input                       clk,
    input                       rst_n
);
    logic                       psel;
    logic                       penable;
    logic   [31:0]              paddr;
    logic                       pwrite;
    logic   [31:0]              pwdata;
    logic                       pready;
    logic   [31:0]              prdata;
    logic                       pslverr;

    // synthesizable, for design
    modport MST (
        output                  psel, penable, paddr, pwrite, pwdata,
        input                   pready, prdata, pslverr
    );

    modport SLV (
        input                   psel, penable, paddr, pwrite, pwdata,
        output                  pready, prdata, pslverr
    );

    // for verification only
    // synthesis translate_off
    clocking MST_CB @(posedge clk);
        default input #0.1 output #0.1; // sample -0.1ns before posedge
                                        // drive 0.1ns after posedge
        output                      psel, penable, paddr, pwrite, pwdata;
        input                       pready, prdata, pslverr;
    endclocking

    clocking SLV_CB @(posedge clk);
        default input #0.1 output #0.1; // sample -0.1ns before posedge
                                        // drive 0.1ns after posedge
        input                       psel, penable, paddr, pwrite, pwdata;
        output                      pready, prdata, pslverr;
    endclocking

    clocking MON_CB @(posedge clk);
        default input #0.1 output #0.1; // sample -0.1ns before posedge
                                        // drive 0.1ns after posedge
        input                       psel, penable, paddr, pwrite, pwdata;
        input                       pready, prdata, pslverr;
    endclocking

    modport MST_TB (clocking MST_CB, input clk, rst_n);
    modport SLV_TB (clocking SLV_CB, input clk, rst_n);

    task automatic init();
        psel                        = 1'b0;
        penable                     = 'hx;
        paddr                       = 'hx;
        pwrite                      = 'hx;
        pwdata                      = 'hx;
    endtask

    task automatic write (
        input    [31:0]  addr,
        input    [31:0]  data
    );
        MST_CB.psel                 <= 1'b1;
        MST_CB.penable              <= 1'b0;
        MST_CB.paddr                <= addr;
        MST_CB.pwrite               <= 1'b1;
        MST_CB.pwdata               <= data;
        @(posedge clk);
        MST_CB.penable              <= 1'b1;
        @(posedge clk);

        while (pready!=1'b1) begin
            @(posedge clk);
        end

        MST_CB.psel                 <= 1'b0;
        MST_CB.penable              <= 'hx;
        MST_CB.paddr                <= 'hx;
        MST_CB.pwrite               <= 'hx;
        MST_CB.pwdata               <= 'hx;
    endtask

    task automatic read (
        input     [31:0]  addr,
        output    [31:0]  data
    );
        MST_CB.psel                 <= 1'b1;
        MST_CB.penable              <= 1'b0;
        MST_CB.paddr                <= addr;
        MST_CB.pwrite               <= 1'b0;
        MST_CB.pwdata               <= 'hx;
        @(posedge clk);
        MST_CB.penable              <= 1'b1;
        @(posedge clk);

        while (pready==1'b0) begin
            @(posedge clk);
        end
        while (pready!=1'b1) begin
            @(posedge clk);
        end

        MST_CB.psel                 <= 1'b0;
        MST_CB.penable              <= 'hx;
        MST_CB.paddr                <= 'hx;
        MST_CB.pwrite               <= 'hx;
        MST_CB.pwdata               <= 'hx;

        data                        = prdata;
    endtask
    // synthesis translate_on

endinterface
