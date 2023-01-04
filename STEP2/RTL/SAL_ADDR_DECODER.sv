`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

module SAL_ADDR_DECODER
(
    // clock & reset
    input                       clk,
    input                       rst_n,

    // request from the AXI side
    AXI_A_IF.DST                axi_ar_if,
    AXI_A_IF.DST                axi_aw_if,

    // request to bank controller
    BK_REQ_IF.SRC               bk_req_if
);

    always_comb begin
        axi_aw_if.aready                = 1'b0;
        axi_ar_if.aready                = 1'b0;

        if (axi_aw_if.avalid) begin
            // WR (addr/data) are ready
            bk_req_if.id                = axi_aw_if.aid;
            bk_req_if.ra                = get_dram_ra(axi_aw_if.aaddr);
            bk_req_if.ca                = get_dram_ca(axi_aw_if.aaddr);
            bk_req_if.len               = axi_aw_if.alen;
            bk_req_if.wr                = 1'b1;
            bk_req_if.valid             = axi_aw_if.avalid;
            axi_aw_if.aready            = bk_req_if.ready;
        end
        else
        begin
            // RD (addr) are ready
            bk_req_if.id                = axi_ar_if.aid;
            bk_req_if.ra                = get_dram_ra(axi_ar_if.aaddr);
            bk_req_if.ca                = get_dram_ca(axi_ar_if.aaddr);
            bk_req_if.len               = axi_ar_if.alen;
            bk_req_if.wr                = 1'b0;
            bk_req_if.valid             = axi_ar_if.avalid;
            axi_ar_if.aready            = bk_req_if.ready;
        end
    end

endmodule // SAL_ADDR_DECODER
