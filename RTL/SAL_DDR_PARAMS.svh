`ifndef __SAL_DDR_TYPEDEF_SVH__
`define __SAL_DDR_TYPEDEF_SVH__

`define CLK_PERIOD                              2.5

//----------------------------------------------------------
// AXI interface
//----------------------------------------------------------
`define AXI_READ_ACCEPTANCE_CAP                 8
`define AXI_WRITE_ACCEPTANCE_CAP                1

`define AXI_ID_WIDTH                            4
`define AXI_ADDR_WIDTH                          32
`define AXI_DATA_WIDTH                          128
`define AXI_STRB_WIDTH                          (`AXI_DATA_WIDTH/8)
`define AXI_LEN_WIDTH                           4
`define AXI_SIZE_WIDTH                          3
`define AXI_BURST_WIDTH                         2
`define AXI_RESP_WIDTH                          2

`define AXI_SIZE_8                              3'b000
`define AXI_SIZE_16                             3'b001
`define AXI_SIZE_32                             3'b010
`define AXI_SIZE_64                             3'b011
`define AXI_SIZE_128                            3'b100

`define AXI_BURST_FIXED                         2'b00
`define AXI_BURST_INCR                          2'b01
`define AXI_BURST_WRAP                          2'b11

`define AXI_RESP_OKAY                           2'b00
`define AXI_RESP_EXOKAY                         2'b01
`define AXI_RESP_SLVERR                         2'b10
`define AXI_RESP_DECERR                         2'b11

typedef logic   [`AXI_ID_WIDTH-1:0]             axi_id_t;
typedef logic   [`AXI_ADDR_WIDTH-1:0]           axi_addr_t;
typedef logic   [`AXI_DATA_WIDTH-1:0]           axi_data_t;
typedef logic   [`AXI_STRB_WIDTH-1:0]           axi_strb_t;
typedef logic   [`AXI_LEN_WIDTH-1:0]            axi_len_t;
typedef logic   [`AXI_SIZE_WIDTH-1:0]           axi_size_t;
typedef logic   [`AXI_BURST_WIDTH-1:0]          axi_burst_t;
typedef logic   [`AXI_RESP_WIDTH-1:0]           axi_resp_t;

// MC interface
`define MC_BA_WIDTH                             2
`define MC_RA_WIDTH                             13
`define MC_CA_WIDTH                             8

`define MC_SEQ_NUM_WIDTH                        $clog2(`AXI_READ_ACCEPTANCE_CAP)

typedef logic   [`MC_BA_WIDTH-1:0]              mc_ba_t;
typedef logic   [`MC_RA_WIDTH-1:0]              mc_ra_t;
typedef logic   [`MC_CA_WIDTH-1:0]              mc_ca_t;
typedef logic   [`MC_SEQ_NUM_WIDTH-1:0]         seq_num_t;

// DFI interface
`define DFI_CS_WIDTH                            2
`define DFI_BA_WIDTH                            3
`define DFI_ADDR_WIDTH                          14

// DRAM interface
`define DRAM_CS_WIDTH                           `DFI_CS_WIDTH
`define DRAM_BA_WIDTH                           `DFI_BA_WIDTH
`define DRAM_RA_WIDTH                           13
`define DRAM_CA_WIDTH                           8
`define DRAM_ADDR_WIDTH                         `DFI_ADDR_WIDTH

`define BURST_LENGTH                            4

`define CAS_LATENCY                             5
`define WRITE_LATENCY                           4

// derived parameters
`define DRAM_BK_CNT                             (1<<`DRAM_BA_WIDTH)

// DRAM timing
`include "ddr2_model_parameters.vh"

`define ROUND_UP(x)                             ((x+int'(`CLK_PERIOD*1000)-1)/(int'(`CLK_PERIOD*1000)))

`define T_RC_WIDTH                              5
`define T_RC_VALUE_M1                           (`ROUND_UP(TRC)-1)
`define T_RCD_WIDTH                             3
`define T_RCD_VALUE_M1                          (`ROUND_UP(TRCD)-1)
`define T_RP_WIDTH                              3
`define T_RP_VALUE_M1                           (`ROUND_UP(TRP)-1)
`define T_RAS_WIDTH                             5
`define T_RAS_VALUE_M1                          (`ROUND_UP(TRAS_MIN)-1)
`define T_RFC_WIDTH                             8
`define T_RFC_VALUE_M1                          (`ROUND_UP(TRFC_MIN)-1)
`define T_RTP_WIDTH                             3
`define T_RTP_VALUE_M1                          (`ROUND_UP(TRTP)-1)
`define T_WTP_WIDTH                             4
// based on figure 63 (WRITE-to-PRECHARGE) in Micron DDR2 datasheet
`define T_WTP_VALUE_M1                          (`WRITE_LATENCY+`BURST_LENGTH/2+`ROUND_UP(TWR)-1)
`define ROW_OPEN_WIDTH                          6
`define ROW_OPEN_CNT                            31
`define BURST_CYCLE_WIDTH                       2
`define BURST_CYCLE_VALUE_M2                    (`BURST_LENGTH/2-2)

`define T_RRD_WIDTH                             4
`define T_RRD_VALUE_M1                          (`ROUND_UP(TRRD)-1)
`define T_CCD_WIDTH                             2
`define T_CCD_VALUE_M1                          (TCCD-1)      // in clock cycles
`define T_WTR_WIDTH                             8
// based on table 40 in Micron DDR2 datasheet
`define T_WTR_VALUE_M1                          (`CAS_LATENCY -1 + `BURST_LENGTH/2 + `ROUND_UP(TWTR)-1)
`define T_RTW_WIDTH                             8
// based on table 40 in Micron DDR2 datasheet
`define T_RTW_VALUE_M1                          (`BURST_LENGTH/2 + 2-1)
`define T_FAW_VALUE                             (`ROUND_UP(TFAW))

//----------------------------------------------------------
// Address mapping
//----------------------------------------------------------
// 10987654321098765432109876543210
//         -------------        ---
//            row               offset (3-bit for 64-DQ (or 8B))
//                      --------
//                       column (8-bit)
function [`DRAM_BA_WIDTH-1:0] get_dram_ba(input [`AXI_ADDR_WIDTH-1:0] addr);
    return addr[(`DRAM_CA_WIDTH+3)+:`DRAM_BA_WIDTH];
endfunction

function [`DRAM_RA_WIDTH-1:0] get_dram_ra(input [`AXI_ADDR_WIDTH-1:0] addr);
    return addr[(`DRAM_BA_WIDTH+`DRAM_CA_WIDTH+3)+:`DRAM_RA_WIDTH];
endfunction

function [`DRAM_CA_WIDTH-1:0] get_dram_ca(input [`AXI_ADDR_WIDTH-1:0] addr);
    return addr[`DRAM_CA_WIDTH+2:3];
endfunction

`endif /* __SAL_DDR_TYPEDEF_SVH__ */
