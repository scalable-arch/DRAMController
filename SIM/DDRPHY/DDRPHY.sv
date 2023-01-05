`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

module DDRPHY
(
    input   wire                    clk,
    input   wire                    rst_n,

    // DFI interface (interface with the controller)
    DFI_CTRL_IF.DST                 dfi_ctrl_if,
    DFI_WR_IF.DST                   dfi_wr_if,
    DFI_RD_IF.SRC                   dfi_rd_if,

    // command and address
    output  logic                   ck,
    output  logic                   ck_n,
    output  logic                   cke,
    output  logic   [`DRAM_CS_WIDTH-1:0]    cs_n,
    output  logic                   ras_n,
    output  logic                   cas_n,
    output  logic                   we_n,
    output  logic   [`DRAM_BA_WIDTH-1:0]    ba,
    output  logic   [`DRAM_ADDR_WIDTH-1:0]  addr,
    output  logic                   odt,

    //data
    inout   logic   [63:0]          dq,
    inout   logic   [7:0]           dqs,
    inout   logic   [7:0]           dqs_n,
    inout   logic   [7:0]           dm_rdqs,
    input   logic   [7:0]           rdqs_n
);

    assign  ck                      = clk;
    assign  ck_n                    = ~clk;

    // delay control signals by a half cycle to align the signals
    always_ff @(negedge clk) begin  // NEGedge
        cke                         <= dfi_ctrl_if.cke;
        cs_n                        <= dfi_ctrl_if.cs_n;
        ras_n                       <= dfi_ctrl_if.ras_n;
        cas_n                       <= dfi_ctrl_if.cas_n;
        we_n                        <= dfi_ctrl_if.we_n;
        ba                          <= dfi_ctrl_if.ba;
        addr                        <= dfi_ctrl_if.addr;
        odt                         <= dfi_ctrl_if.odt;
    end

    //----------------------------------------------------------
    // Write path
    //----------------------------------------------------------
    logic                           wren,       wren_d1;
    logic   [127:0]                 wdata;
    logic   [15:0]                  wmask;

    always_ff @(posedge clk) begin
        wren                        <= dfi_wr_if.wrdata_en;
        wren_d1                     <= wren;
        wdata                       <= dfi_wr_if.wrdata;
        wmask                       <= dfi_wr_if.wrdata_mask;
    end

    //
    wire    [63:0]                  wdata_ddr;
    assign  wdata_ddr               = clk ? wdata[127:64] : wdata[63:0];
    assign  wmask_ddr               = clk ? wmask[15:8] : wmask[7:0];

    assign  dqs                     =  (wren & !wren_d1)
                                     ? 8'h00 // preamble
                                     : (wren_d1) ? {8{clk}}
                                              : 8'hz;
    assign  dqs_n                   =  (wren & !wren_d1)
                                     ? 8'hFF // preamble
                                     : (wren_d1) ? {8{~clk}}
                                              : 8'hz;
    assign  #(`CLK_PERIOD*3/4)  dq  = wren ? wdata_ddr : 'hz;
    assign  #(`CLK_PERIOD*3/4)  dm_rdqs = wren ? wmask_ddr : 'hz;

    //----------------------------------------------------------
    // Read path
    //----------------------------------------------------------

    //----------------------------------------------------------
    // DQS cleaning: DQS is bidirectional.
    // -> need to clean DQS to extract rDQS only
    logic                           rden_neg_d;
    always_ff @(negedge clk) begin  // NEGedge
        rden_neg_d                  <= dfi_rd_if.rddata_en;
    end

    logic                           clean_rdqs;
    assign  clean_rdqs              = dqs[0] & rden_neg_d;

    //----------------------------------------------------------
    // Capture DQ using clean DQS
    logic   [63:0]                  rdata_posedge,
                                    rdata_negedge;
    always_ff @(posedge clean_rdqs) begin
        rdata_posedge               <= dq;
    end
    always_ff @(negedge clean_rdqs) begin
        rdata_negedge               <= dq;
    end

    //----------------------------------------------------------
    // Provide read data to MC
    logic   [1:0]                   rden_shift_reg;
    always_ff @(posedge clk)
        if (~rst_n)
            rden_shift_reg          <= 'd0;
        else
            rden_shift_reg          <= {rden_shift_reg[0], dfi_rd_if.rddata_en};

    assign  dfi_rd_if.rddata_valid  = rden_shift_reg[1];
    assign  dfi_rd_if.rddata        = {rdata_posedge, rdata_negedge};

endmodule
