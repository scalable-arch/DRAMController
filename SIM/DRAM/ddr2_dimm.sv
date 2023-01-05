`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

module ddr2_dimm (
    input   wire                ck,
    input   wire                ck_n,
    input   wire                cke,
    input   wire                cs_n,
    input   wire                ras_n,
    input   wire                cas_n,
    input   wire                we_n,
    input   wire    [`DRAM_BA_WIDTH-1:0]    ba,
    input   wire    [`DRAM_ADDR_WIDTH-1:0]  addr,
    input   wire                odt,
    inout   wire    [63:0]      dq,
    inout   wire    [7:0]       dqs,
    inout   wire    [7:0]       dqs_n,
    inout   wire    [7:0]       rdqs_n,
    inout   wire    [7:0]       dm_rdqs
);

    ddr2_model                      u_dram0
        (
            // command and address
            .ck                         (ck),
            .ck_n                       (ck_n),
            .cke                        (cke),
            .cs_n                       (cs_n),
            .ras_n                      (ras_n),
            .cas_n                      (cas_n),
            .we_n                       (we_n),
            .ba                         (ba),
            .addr                       (addr),
            .odt                        (odt),

            // data
            .dq                         (dq[7:0]),
            .dqs                        (dqs[0]),
            .dqs_n                      (dqs_n[0]),
            .dm_rdqs                    (dm_rdqs[0]),
            .rdqs_n                     (rdqs_n[0])
        );

        ddr2_model                      u_dram1
        (
            // command and address
            .ck                         (ck),
            .ck_n                       (ck_n),
            .cke                        (cke),
            .cs_n                       (cs_n),
            .ras_n                      (ras_n),
            .cas_n                      (cas_n),
            .we_n                       (we_n),
            .ba                         (ba),
            .addr                       (addr),
            .odt                        (odt),

            // data
            .dq                         (dq[15:8]),
            .dqs                        (dqs[1]),
            .dqs_n                      (dqs_n[1]),
            .dm_rdqs                    (dm_rdqs[1]),
            .rdqs_n                     (rdqs_n[1])
        );

        ddr2_model                      u_dram2
        (
            // command and address
            .ck                         (ck),
            .ck_n                       (ck_n),
            .cke                        (cke),
            .cs_n                       (cs_n),
            .ras_n                      (ras_n),
            .cas_n                      (cas_n),
            .we_n                       (we_n),
            .ba                         (ba),
            .addr                       (addr),
            .odt                        (odt),

            // data
            .dq                         (dq[23:16]),
            .dqs                        (dqs[2]),
            .dqs_n                      (dqs_n[2]),
            .dm_rdqs                    (dm_rdqs[2]),
            .rdqs_n                     (rdqs_n[2])
        );

        ddr2_model                      u_dram3
        (
            // command and address
            .ck                         (ck),
            .ck_n                       (ck_n),
            .cke                        (cke),
            .cs_n                       (cs_n),
            .ras_n                      (ras_n),
            .cas_n                      (cas_n),
            .we_n                       (we_n),
            .ba                         (ba),
            .addr                       (addr),
            .odt                        (odt),

            // data
            .dq                         (dq[31:24]),
            .dqs                        (dqs[3]),
            .dqs_n                      (dqs_n[3]),
            .dm_rdqs                    (dm_rdqs[3]),
            .rdqs_n                     (rdqs_n[3])
        );

        ddr2_model                      u_dram4
        (
            // command and address
            .ck                         (ck),
            .ck_n                       (ck_n),
            .cke                        (cke),
            .cs_n                       (cs_n),
            .ras_n                      (ras_n),
            .cas_n                      (cas_n),
            .we_n                       (we_n),
            .ba                         (ba),
            .addr                       (addr),
            .odt                        (odt),

            // data
            .dq                         (dq[39:32]),
            .dqs                        (dqs[4]),
            .dqs_n                      (dqs_n[4]),
            .dm_rdqs                    (dm_rdqs[4]),
            .rdqs_n                     (rdqs_n[4])
        );

        ddr2_model                      u_dram5
        (
            // command and address
            .ck                         (ck),
            .ck_n                       (ck_n),
            .cke                        (cke),
            .cs_n                       (cs_n),
            .ras_n                      (ras_n),
            .cas_n                      (cas_n),
            .we_n                       (we_n),
            .ba                         (ba),
            .addr                       (addr),
            .odt                        (odt),

            // data
            .dq                         (dq[47:40]),
            .dqs                        (dqs[5]),
            .dqs_n                      (dqs_n[5]),
            .dm_rdqs                    (dm_rdqs[5]),
            .rdqs_n                     (rdqs_n[5])
        );

        ddr2_model                      u_dram6
        (
            // command and address
            .ck                         (ck),
            .ck_n                       (ck_n),
            .cke                        (cke),
            .cs_n                       (cs_n),
            .ras_n                      (ras_n),
            .cas_n                      (cas_n),
            .we_n                       (we_n),
            .ba                         (ba),
            .addr                       (addr),
            .odt                        (odt),

            // data
            .dq                         (dq[55:48]),
            .dqs                        (dqs[6]),
            .dqs_n                      (dqs_n[6]),
            .dm_rdqs                    (dm_rdqs[6]),
            .rdqs_n                     (rdqs_n[6])
        );

        ddr2_model                      u_dram7
        (
            // command and address
            .ck                         (ck),
            .ck_n                       (ck_n),
            .cke                        (cke),
            .cs_n                       (cs_n),
            .ras_n                      (ras_n),
            .cas_n                      (cas_n),
            .we_n                       (we_n),
            .ba                         (ba),
            .addr                       (addr),
            .odt                        (odt),

            // data
            .dq                         (dq[63:56]),
            .dqs                        (dqs[7]),
            .dqs_n                      (dqs_n[7]),
            .dm_rdqs                    (dm_rdqs[7]),
            .rdqs_n                     (rdqs_n[7])
        );


        initial begin
            repeat (5) @(posedge ck);
            u_dram0.initialize({1'b0,    // reserved
                               1'd0,    // fast exit
                               3'd5,    // write recover=6
                               1'b0,    // DLL reset
                               1'b0,    // normal
                               3'd`CAS_LATENCY,    // CAS latency=5
                               1'b0,    // interleaved
                               3'd2},   // BL4
                              'h0, 'h0, 'h0
                              );
            u_dram1.initialize({1'b0,    // reserved
                               1'd0,    // fast exit
                               3'd5,    // write recover=6
                               1'b0,    // DLL reset
                               1'b0,    // normal
                               3'd`CAS_LATENCY,    // CAS latency=5
                               1'b0,    // interleaved
                               3'd2},   // BL4
                              'h0, 'h0, 'h0
                              );
            u_dram2.initialize({1'b0,    // reserved
                               1'd0,    // fast exit
                               3'd5,    // write recover=6
                               1'b0,    // DLL reset
                               1'b0,    // normal
                               3'd`CAS_LATENCY,    // CAS latency=5
                               1'b0,    // interleaved
                               3'd2},   // BL4
                              'h0, 'h0, 'h0
                              );
            u_dram3.initialize({1'b0,    // reserved
                               1'd0,    // fast exit
                               3'd5,    // write recover=6
                               1'b0,    // DLL reset
                               1'b0,    // normal
                               3'd`CAS_LATENCY,    // CAS latency=5
                               1'b0,    // interleaved
                               3'd2},   // BL4
                              'h0, 'h0, 'h0
                              );
            u_dram4.initialize({1'b0,    // reserved
                               1'd0,    // fast exit
                               3'd5,    // write recover=6
                               1'b0,    // DLL reset
                               1'b0,    // normal
                               3'd`CAS_LATENCY,    // CAS latency=5
                               1'b0,    // interleaved
                               3'd2},   // BL4
                              'h0, 'h0, 'h0
                              );
            u_dram5.initialize({1'b0,    // reserved
                               1'd0,    // fast exit
                               3'd5,    // write recover=6
                               1'b0,    // DLL reset
                               1'b0,    // normal
                               3'd`CAS_LATENCY,    // CAS latency=5
                               1'b0,    // interleaved
                               3'd2},   // BL4
                              'h0, 'h0, 'h0
                              );
            u_dram6.initialize({1'b0,    // reserved
                               1'd0,    // fast exit
                               3'd5,    // write recover=6
                               1'b0,    // DLL reset
                               1'b0,    // normal
                               3'd`CAS_LATENCY,    // CAS latency=5
                               1'b0,    // interleaved
                               3'd2},   // BL4
                              'h0, 'h0, 'h0
                              );
            u_dram7.initialize({1'b0,    // reserved
                               1'd0,    // fast exit
                               3'd5,    // write recover=6
                               1'b0,    // DLL reset
                               1'b0,    // normal
                               3'd`CAS_LATENCY,// CAS latency=5
                               1'b0,    // sequential
                               3'd2},   // BL4
                              'h400,    // DQS# Disable
                              'h0, 'h0
                              );
        end

endmodule
