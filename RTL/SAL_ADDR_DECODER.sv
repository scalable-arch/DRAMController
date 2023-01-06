`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

module SAL_ADDR_DECODER
(
    // clock & reset
    input                       clk,
    input                       rst_n,

    // request from the AXI side
    AXI_IF.SLV_AR               axi_ar_if,
    AXI_IF.SLV_AW               axi_aw_if,

    // requests to bank controllers
    REQ_IF.SRC                  req_if_arr[`DRAM_BK_CNT]
);

    logic                           valid;
    logic                           wr;
    logic   [`AXI_ID_WIDTH-1:0]     id;
    logic   [`AXI_LEN_WIDTH-1:0]    len;
    logic   [`DRAM_BA_WIDTH-1:0]    ba;
    logic   [`DRAM_RA_WIDTH-1:0]    ra;
    logic   [`DRAM_CA_WIDTH-1:0]    ca;

    always_comb begin
        valid                           = 1'b0;
        wr                              = 'bx;
        id                              = 'hx;
        len                             = 'hx;
        ba                              = 'hx;
        ra                              = 'hx;
        ca                              = 'hx;

        // temporary AW takes precedency over AR
        // because AW has buffered its data in W and has waited longer
        //
        // TODO: Support concurrent requests from AW and AR
        //       if they target different banks
        if (axi_aw_if.awvalid) begin
            // WR (addr/data) are ready
            valid                           = 1'b1;
            wr                              = 1'b1;
            id                              = axi_aw_if.awid;
            len                             = axi_aw_if.awlen;
            ba                              = get_dram_ba(axi_aw_if.awaddr);
            ra                              = get_dram_ra(axi_aw_if.awaddr);
            ca                              = get_dram_ca(axi_aw_if.awaddr);
        end
        else if (axi_ar_if.arvalid) begin
            // RD (addr) are ready
            valid                           = 1'b1;
            wr                              = 1'b0;
            id                              = axi_ar_if.arid;
            len                             = axi_ar_if.arlen;
            ba                              = get_dram_ba(axi_ar_if.araddr);
            ra                              = get_dram_ra(axi_ar_if.araddr);
            ca                              = get_dram_ca(axi_ar_if.araddr);
        end
    end

    wire    [`DRAM_BK_CNT-1:0]      ready_bit_vector;

    genvar geni;
    generate
        for (geni=0; geni<`DRAM_BK_CNT; geni=geni+1) begin
            // broadcast signals
            assign  req_if_arr[geni].id             = id;
            assign  req_if_arr[geni].ra             = ra;
            assign  req_if_arr[geni].ca             = ca;
            assign  req_if_arr[geni].len            = len;
            assign  req_if_arr[geni].wr             = wr;

            // assert valid to selected bank only
            assign  req_if_arr[geni].valid          = valid & (ba==geni);
            // connect ready from the selected bank to the requesting
            // interface
            assign  ready_bit_vector[geni]          = req_if_arr[geni].ready & (ba==geni);
        end
    endgenerate

    assign  axi_aw_if.awready               = wr & (|ready_bit_vector);
    assign  axi_ar_if.arready               = !wr & (|ready_bit_vector);

endmodule // SAL_ADDR_DECODER
