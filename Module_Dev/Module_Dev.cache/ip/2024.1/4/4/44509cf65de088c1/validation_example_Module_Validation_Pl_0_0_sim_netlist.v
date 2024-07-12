// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
// Date        : Thu Jul 11 18:13:20 2024
// Host        : Barry-Home-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ validation_example_Module_Validation_Pl_0_0_sim_netlist.v
// Design      : validation_example_Module_Validation_Pl_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0
   (S_AXI_WREADY,
    S_AXI_AWREADY,
    Q,
    SR,
    \write_buffer_reg[0][7] ,
    \write_buffer_reg[1][7] ,
    \write_buffer_reg[2][7] ,
    \write_buffer_reg[3][7] ,
    bram_en_a,
    S_AXI_ARREADY,
    s00_axi_rdata,
    bram_we_a,
    clk_o,
    s00_axi_rvalid,
    s00_axi_bvalid,
    s00_axi_awvalid,
    s00_axi_wvalid,
    s00_axi_wstrb,
    s00_axi_awaddr,
    s00_axi_aclk,
    s00_axi_wdata,
    perph_i,
    s00_axi_araddr,
    s00_axi_arvalid,
    s00_axi_aresetn,
    bram_rddata_a,
    s00_axi_bready,
    s00_axi_rready);
  output S_AXI_WREADY;
  output S_AXI_AWREADY;
  output [11:0]Q;
  output [0:0]SR;
  output [7:0]\write_buffer_reg[0][7] ;
  output [7:0]\write_buffer_reg[1][7] ;
  output [7:0]\write_buffer_reg[2][7] ;
  output [7:0]\write_buffer_reg[3][7] ;
  output bram_en_a;
  output S_AXI_ARREADY;
  output [31:0]s00_axi_rdata;
  output bram_we_a;
  output clk_o;
  output s00_axi_rvalid;
  output s00_axi_bvalid;
  input s00_axi_awvalid;
  input s00_axi_wvalid;
  input [3:0]s00_axi_wstrb;
  input [2:0]s00_axi_awaddr;
  input s00_axi_aclk;
  input [31:0]s00_axi_wdata;
  input [31:0]perph_i;
  input [2:0]s00_axi_araddr;
  input s00_axi_arvalid;
  input s00_axi_aresetn;
  input [31:0]bram_rddata_a;
  input s00_axi_bready;
  input s00_axi_rready;

  wire [11:0]Q;
  wire [0:0]SR;
  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire bram_en_a;
  wire [31:0]bram_rddata_a;
  wire bram_we_a;
  wire clk_o;
  wire [31:0]perph_i;
  wire s00_axi_aclk;
  wire [2:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [2:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire [7:0]\write_buffer_reg[0][7] ;
  wire [7:0]\write_buffer_reg[1][7] ;
  wire [7:0]\write_buffer_reg[2][7] ;
  wire [7:0]\write_buffer_reg[3][7] ;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0_S00_AXI Module_Validation_Platform_v1_0_S00_AXI_inst
       (.S_AXI_ARREADY(S_AXI_ARREADY),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_WREADY(S_AXI_WREADY),
        .bram_addr_a(Q),
        .bram_en_a(bram_en_a),
        .bram_rddata_a(bram_rddata_a),
        .bram_we_a(bram_we_a),
        .clk_o(clk_o),
        .perph_i(perph_i),
        .perph_o({\write_buffer_reg[3][7] ,\write_buffer_reg[2][7] ,\write_buffer_reg[1][7] ,\write_buffer_reg[0][7] }),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_araddr(s00_axi_araddr),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_aresetn_0(SR),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0_S00_AXI
   (S_AXI_WREADY,
    S_AXI_AWREADY,
    bram_addr_a,
    s00_axi_aresetn_0,
    perph_o,
    bram_en_a,
    S_AXI_ARREADY,
    s00_axi_rdata,
    bram_we_a,
    clk_o,
    s00_axi_rvalid,
    s00_axi_bvalid,
    s00_axi_awvalid,
    s00_axi_wvalid,
    s00_axi_wstrb,
    s00_axi_awaddr,
    s00_axi_aclk,
    s00_axi_wdata,
    perph_i,
    s00_axi_araddr,
    s00_axi_arvalid,
    s00_axi_aresetn,
    bram_rddata_a,
    s00_axi_bready,
    s00_axi_rready);
  output S_AXI_WREADY;
  output S_AXI_AWREADY;
  output [11:0]bram_addr_a;
  output s00_axi_aresetn_0;
  output [31:0]perph_o;
  output bram_en_a;
  output S_AXI_ARREADY;
  output [31:0]s00_axi_rdata;
  output bram_we_a;
  output clk_o;
  output s00_axi_rvalid;
  output s00_axi_bvalid;
  input s00_axi_awvalid;
  input s00_axi_wvalid;
  input [3:0]s00_axi_wstrb;
  input [2:0]s00_axi_awaddr;
  input s00_axi_aclk;
  input [31:0]s00_axi_wdata;
  input [31:0]perph_i;
  input [2:0]s00_axi_araddr;
  input s00_axi_arvalid;
  input s00_axi_aresetn;
  input [31:0]bram_rddata_a;
  input s00_axi_bready;
  input s00_axi_rready;

  wire Platform_IO_inst_n_0;
  wire Platform_IO_inst_n_1;
  wire Platform_IO_inst_n_10;
  wire Platform_IO_inst_n_11;
  wire Platform_IO_inst_n_12;
  wire Platform_IO_inst_n_13;
  wire Platform_IO_inst_n_14;
  wire Platform_IO_inst_n_15;
  wire Platform_IO_inst_n_16;
  wire Platform_IO_inst_n_17;
  wire Platform_IO_inst_n_18;
  wire Platform_IO_inst_n_19;
  wire Platform_IO_inst_n_2;
  wire Platform_IO_inst_n_20;
  wire Platform_IO_inst_n_21;
  wire Platform_IO_inst_n_22;
  wire Platform_IO_inst_n_23;
  wire Platform_IO_inst_n_24;
  wire Platform_IO_inst_n_25;
  wire Platform_IO_inst_n_26;
  wire Platform_IO_inst_n_27;
  wire Platform_IO_inst_n_28;
  wire Platform_IO_inst_n_29;
  wire Platform_IO_inst_n_3;
  wire Platform_IO_inst_n_30;
  wire Platform_IO_inst_n_31;
  wire Platform_IO_inst_n_32;
  wire Platform_IO_inst_n_4;
  wire Platform_IO_inst_n_5;
  wire Platform_IO_inst_n_6;
  wire Platform_IO_inst_n_7;
  wire Platform_IO_inst_n_8;
  wire Platform_IO_inst_n_9;
  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire aw_en_i_1_n_0;
  wire aw_en_reg_n_0;
  wire [4:2]axi_araddr;
  wire \axi_araddr[2]_i_1_n_0 ;
  wire \axi_araddr[3]_i_1_n_0 ;
  wire \axi_araddr[4]_i_1_n_0 ;
  wire axi_arready0;
  wire \axi_awaddr[2]_i_1_n_0 ;
  wire \axi_awaddr[3]_i_1_n_0 ;
  wire \axi_awaddr[4]_i_1_n_0 ;
  wire axi_awready0;
  wire axi_bvalid_i_1_n_0;
  wire \axi_rdata[0]_i_3_n_0 ;
  wire \axi_rdata[0]_i_6_n_0 ;
  wire \axi_rdata[10]_i_3_n_0 ;
  wire \axi_rdata[10]_i_6_n_0 ;
  wire \axi_rdata[11]_i_3_n_0 ;
  wire \axi_rdata[11]_i_6_n_0 ;
  wire \axi_rdata[12]_i_3_n_0 ;
  wire \axi_rdata[12]_i_6_n_0 ;
  wire \axi_rdata[13]_i_3_n_0 ;
  wire \axi_rdata[13]_i_6_n_0 ;
  wire \axi_rdata[14]_i_3_n_0 ;
  wire \axi_rdata[14]_i_6_n_0 ;
  wire \axi_rdata[15]_i_3_n_0 ;
  wire \axi_rdata[15]_i_6_n_0 ;
  wire \axi_rdata[16]_i_3_n_0 ;
  wire \axi_rdata[16]_i_6_n_0 ;
  wire \axi_rdata[17]_i_3_n_0 ;
  wire \axi_rdata[17]_i_6_n_0 ;
  wire \axi_rdata[18]_i_3_n_0 ;
  wire \axi_rdata[18]_i_6_n_0 ;
  wire \axi_rdata[19]_i_3_n_0 ;
  wire \axi_rdata[19]_i_6_n_0 ;
  wire \axi_rdata[1]_i_3_n_0 ;
  wire \axi_rdata[1]_i_6_n_0 ;
  wire \axi_rdata[20]_i_3_n_0 ;
  wire \axi_rdata[20]_i_6_n_0 ;
  wire \axi_rdata[21]_i_3_n_0 ;
  wire \axi_rdata[21]_i_6_n_0 ;
  wire \axi_rdata[22]_i_3_n_0 ;
  wire \axi_rdata[22]_i_6_n_0 ;
  wire \axi_rdata[23]_i_3_n_0 ;
  wire \axi_rdata[23]_i_6_n_0 ;
  wire \axi_rdata[24]_i_3_n_0 ;
  wire \axi_rdata[24]_i_6_n_0 ;
  wire \axi_rdata[25]_i_3_n_0 ;
  wire \axi_rdata[25]_i_6_n_0 ;
  wire \axi_rdata[26]_i_3_n_0 ;
  wire \axi_rdata[26]_i_6_n_0 ;
  wire \axi_rdata[27]_i_3_n_0 ;
  wire \axi_rdata[27]_i_6_n_0 ;
  wire \axi_rdata[28]_i_3_n_0 ;
  wire \axi_rdata[28]_i_6_n_0 ;
  wire \axi_rdata[29]_i_3_n_0 ;
  wire \axi_rdata[29]_i_6_n_0 ;
  wire \axi_rdata[2]_i_3_n_0 ;
  wire \axi_rdata[2]_i_6_n_0 ;
  wire \axi_rdata[30]_i_3_n_0 ;
  wire \axi_rdata[30]_i_6_n_0 ;
  wire \axi_rdata[31]_i_3_n_0 ;
  wire \axi_rdata[31]_i_4_n_0 ;
  wire \axi_rdata[31]_i_7_n_0 ;
  wire \axi_rdata[3]_i_3_n_0 ;
  wire \axi_rdata[4]_i_3_n_0 ;
  wire \axi_rdata[4]_i_6_n_0 ;
  wire \axi_rdata[5]_i_3_n_0 ;
  wire \axi_rdata[5]_i_6_n_0 ;
  wire \axi_rdata[6]_i_3_n_0 ;
  wire \axi_rdata[6]_i_6_n_0 ;
  wire \axi_rdata[7]_i_3_n_0 ;
  wire \axi_rdata[7]_i_6_n_0 ;
  wire \axi_rdata[8]_i_3_n_0 ;
  wire \axi_rdata[8]_i_6_n_0 ;
  wire \axi_rdata[9]_i_3_n_0 ;
  wire \axi_rdata[9]_i_6_n_0 ;
  wire axi_rvalid_i_1_n_0;
  wire axi_wready0;
  wire [11:0]bram_addr_a;
  wire bram_en_a;
  wire [31:0]bram_rddata_a;
  wire bram_we_a;
  wire clk_o;
  wire [2:0]p_0_in_0;
  wire [31:0]perph_i;
  wire [31:0]perph_o;
  wire s00_axi_aclk;
  wire [2:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_aresetn_0;
  wire s00_axi_arvalid;
  wire [2:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire [31:12]slv_reg0;
  wire \slv_reg0[11]_i_1_n_0 ;
  wire \slv_reg0[23]_i_1_n_0 ;
  wire \slv_reg0[31]_i_1_n_0 ;
  wire \slv_reg0[7]_i_1_n_0 ;
  wire [1:0]slv_reg3;
  wire \slv_reg3[15]_i_1_n_0 ;
  wire \slv_reg3[23]_i_1_n_0 ;
  wire \slv_reg3[31]_i_1_n_0 ;
  wire \slv_reg3[3]_i_1_n_0 ;
  wire \slv_reg3[4]_i_1_n_0 ;
  wire \slv_reg3[4]_i_2_n_0 ;
  wire \slv_reg3_reg_n_0_[10] ;
  wire \slv_reg3_reg_n_0_[11] ;
  wire \slv_reg3_reg_n_0_[12] ;
  wire \slv_reg3_reg_n_0_[13] ;
  wire \slv_reg3_reg_n_0_[14] ;
  wire \slv_reg3_reg_n_0_[15] ;
  wire \slv_reg3_reg_n_0_[16] ;
  wire \slv_reg3_reg_n_0_[17] ;
  wire \slv_reg3_reg_n_0_[18] ;
  wire \slv_reg3_reg_n_0_[19] ;
  wire \slv_reg3_reg_n_0_[20] ;
  wire \slv_reg3_reg_n_0_[21] ;
  wire \slv_reg3_reg_n_0_[22] ;
  wire \slv_reg3_reg_n_0_[23] ;
  wire \slv_reg3_reg_n_0_[24] ;
  wire \slv_reg3_reg_n_0_[25] ;
  wire \slv_reg3_reg_n_0_[26] ;
  wire \slv_reg3_reg_n_0_[27] ;
  wire \slv_reg3_reg_n_0_[28] ;
  wire \slv_reg3_reg_n_0_[29] ;
  wire \slv_reg3_reg_n_0_[2] ;
  wire \slv_reg3_reg_n_0_[30] ;
  wire \slv_reg3_reg_n_0_[31] ;
  wire \slv_reg3_reg_n_0_[4] ;
  wire \slv_reg3_reg_n_0_[5] ;
  wire \slv_reg3_reg_n_0_[6] ;
  wire \slv_reg3_reg_n_0_[7] ;
  wire \slv_reg3_reg_n_0_[8] ;
  wire \slv_reg3_reg_n_0_[9] ;
  wire slv_reg_rden__0;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Platform_IO Platform_IO_inst
       (.D({Platform_IO_inst_n_0,Platform_IO_inst_n_1,Platform_IO_inst_n_2,Platform_IO_inst_n_3,Platform_IO_inst_n_4,Platform_IO_inst_n_5,Platform_IO_inst_n_6,Platform_IO_inst_n_7,Platform_IO_inst_n_8,Platform_IO_inst_n_9,Platform_IO_inst_n_10,Platform_IO_inst_n_11,Platform_IO_inst_n_12,Platform_IO_inst_n_13,Platform_IO_inst_n_14,Platform_IO_inst_n_15,Platform_IO_inst_n_16,Platform_IO_inst_n_17,Platform_IO_inst_n_18,Platform_IO_inst_n_19,Platform_IO_inst_n_20,Platform_IO_inst_n_21,Platform_IO_inst_n_22,Platform_IO_inst_n_23,Platform_IO_inst_n_24,Platform_IO_inst_n_25,Platform_IO_inst_n_26,Platform_IO_inst_n_27,Platform_IO_inst_n_28,Platform_IO_inst_n_29,Platform_IO_inst_n_30,Platform_IO_inst_n_31}),
        .Q({bram_addr_a[3],bram_addr_a[1:0]}),
        .SR(s00_axi_aresetn_0),
        .axi_araddr(axi_araddr),
        .\axi_rdata_reg[0] (\axi_rdata[31]_i_3_n_0 ),
        .\axi_rdata_reg[0]_0 (\axi_rdata[0]_i_3_n_0 ),
        .\axi_rdata_reg[0]_1 (\slv_reg3_reg_n_0_[2] ),
        .\axi_rdata_reg[0]_2 (\axi_rdata[0]_i_6_n_0 ),
        .\axi_rdata_reg[10] (\axi_rdata[10]_i_3_n_0 ),
        .\axi_rdata_reg[10]_0 (\axi_rdata[10]_i_6_n_0 ),
        .\axi_rdata_reg[11] (\axi_rdata[11]_i_3_n_0 ),
        .\axi_rdata_reg[11]_0 (\axi_rdata[11]_i_6_n_0 ),
        .\axi_rdata_reg[12] (\axi_rdata[12]_i_3_n_0 ),
        .\axi_rdata_reg[12]_0 (\axi_rdata[12]_i_6_n_0 ),
        .\axi_rdata_reg[13] (\axi_rdata[13]_i_3_n_0 ),
        .\axi_rdata_reg[13]_0 (\axi_rdata[13]_i_6_n_0 ),
        .\axi_rdata_reg[14] (\axi_rdata[14]_i_3_n_0 ),
        .\axi_rdata_reg[14]_0 (\axi_rdata[14]_i_6_n_0 ),
        .\axi_rdata_reg[15] (\axi_rdata[15]_i_3_n_0 ),
        .\axi_rdata_reg[15]_0 (\axi_rdata[15]_i_6_n_0 ),
        .\axi_rdata_reg[16] (\axi_rdata[16]_i_3_n_0 ),
        .\axi_rdata_reg[16]_0 (\axi_rdata[16]_i_6_n_0 ),
        .\axi_rdata_reg[17] (\axi_rdata[17]_i_3_n_0 ),
        .\axi_rdata_reg[17]_0 (\axi_rdata[17]_i_6_n_0 ),
        .\axi_rdata_reg[18] (\axi_rdata[18]_i_3_n_0 ),
        .\axi_rdata_reg[18]_0 (\axi_rdata[18]_i_6_n_0 ),
        .\axi_rdata_reg[19] (\axi_rdata[19]_i_3_n_0 ),
        .\axi_rdata_reg[19]_0 (\axi_rdata[19]_i_6_n_0 ),
        .\axi_rdata_reg[1] (\axi_rdata[1]_i_3_n_0 ),
        .\axi_rdata_reg[1]_0 (\axi_rdata[1]_i_6_n_0 ),
        .\axi_rdata_reg[20] (\axi_rdata[20]_i_3_n_0 ),
        .\axi_rdata_reg[20]_0 (\axi_rdata[20]_i_6_n_0 ),
        .\axi_rdata_reg[21] (\axi_rdata[21]_i_3_n_0 ),
        .\axi_rdata_reg[21]_0 (\axi_rdata[21]_i_6_n_0 ),
        .\axi_rdata_reg[22] (\axi_rdata[22]_i_3_n_0 ),
        .\axi_rdata_reg[22]_0 (\axi_rdata[22]_i_6_n_0 ),
        .\axi_rdata_reg[23] (\axi_rdata[23]_i_3_n_0 ),
        .\axi_rdata_reg[23]_0 (\axi_rdata[23]_i_6_n_0 ),
        .\axi_rdata_reg[24] (\axi_rdata[24]_i_3_n_0 ),
        .\axi_rdata_reg[24]_0 (\axi_rdata[24]_i_6_n_0 ),
        .\axi_rdata_reg[25] (\axi_rdata[25]_i_3_n_0 ),
        .\axi_rdata_reg[25]_0 (\axi_rdata[25]_i_6_n_0 ),
        .\axi_rdata_reg[26] (\axi_rdata[26]_i_3_n_0 ),
        .\axi_rdata_reg[26]_0 (\axi_rdata[26]_i_6_n_0 ),
        .\axi_rdata_reg[27] (\axi_rdata[27]_i_3_n_0 ),
        .\axi_rdata_reg[27]_0 (\axi_rdata[27]_i_6_n_0 ),
        .\axi_rdata_reg[28] (\axi_rdata[28]_i_3_n_0 ),
        .\axi_rdata_reg[28]_0 (\axi_rdata[28]_i_6_n_0 ),
        .\axi_rdata_reg[29] (\axi_rdata[29]_i_3_n_0 ),
        .\axi_rdata_reg[29]_0 (\axi_rdata[29]_i_6_n_0 ),
        .\axi_rdata_reg[2] (\axi_rdata[2]_i_3_n_0 ),
        .\axi_rdata_reg[2]_0 (\axi_rdata[2]_i_6_n_0 ),
        .\axi_rdata_reg[30] (\axi_rdata[30]_i_3_n_0 ),
        .\axi_rdata_reg[30]_0 (\axi_rdata[30]_i_6_n_0 ),
        .\axi_rdata_reg[31] (\axi_rdata[31]_i_4_n_0 ),
        .\axi_rdata_reg[31]_0 (\axi_rdata[31]_i_7_n_0 ),
        .\axi_rdata_reg[3] (\axi_rdata[3]_i_3_n_0 ),
        .\axi_rdata_reg[4] (\axi_rdata[4]_i_3_n_0 ),
        .\axi_rdata_reg[4]_0 (\axi_rdata[4]_i_6_n_0 ),
        .\axi_rdata_reg[5] (\axi_rdata[5]_i_3_n_0 ),
        .\axi_rdata_reg[5]_0 (\axi_rdata[5]_i_6_n_0 ),
        .\axi_rdata_reg[6] (\axi_rdata[6]_i_3_n_0 ),
        .\axi_rdata_reg[6]_0 (\axi_rdata[6]_i_6_n_0 ),
        .\axi_rdata_reg[7] (\axi_rdata[7]_i_3_n_0 ),
        .\axi_rdata_reg[7]_0 (\axi_rdata[7]_i_6_n_0 ),
        .\axi_rdata_reg[8] (\axi_rdata[8]_i_3_n_0 ),
        .\axi_rdata_reg[8]_0 (\axi_rdata[8]_i_6_n_0 ),
        .\axi_rdata_reg[9] (\axi_rdata[9]_i_3_n_0 ),
        .\axi_rdata_reg[9]_0 (\axi_rdata[9]_i_6_n_0 ),
        .bram_rddata_a(bram_rddata_a),
        .p_0_in_0(p_0_in_0),
        .perph_i(perph_i),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid),
        .s00_axi_wvalid_0(Platform_IO_inst_n_32),
        .\write_buffer_reg[0][0]_0 (S_AXI_WREADY),
        .\write_buffer_reg[0][0]_1 (S_AXI_AWREADY),
        .\write_buffer_reg[0][0]_2 (bram_en_a),
        .\write_buffer_reg[0][7]_0 (perph_o[7:0]),
        .\write_buffer_reg[1][7]_0 (perph_o[15:8]),
        .\write_buffer_reg[2][7]_0 (perph_o[23:16]),
        .\write_buffer_reg[3][7]_0 (perph_o[31:24]));
  LUT6 #(
    .INIT(64'hFFFF88880FFF8888)) 
    aw_en_i_1
       (.I0(s00_axi_bvalid),
        .I1(s00_axi_bready),
        .I2(s00_axi_wvalid),
        .I3(s00_axi_awvalid),
        .I4(aw_en_reg_n_0),
        .I5(S_AXI_AWREADY),
        .O(aw_en_i_1_n_0));
  FDSE aw_en_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(aw_en_i_1_n_0),
        .Q(aw_en_reg_n_0),
        .S(s00_axi_aresetn_0));
  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[2]_i_1 
       (.I0(s00_axi_araddr[0]),
        .I1(s00_axi_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[2]),
        .O(\axi_araddr[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[3]_i_1 
       (.I0(s00_axi_araddr[1]),
        .I1(s00_axi_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[3]),
        .O(\axi_araddr[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[4]_i_1 
       (.I0(s00_axi_araddr[2]),
        .I1(s00_axi_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[4]),
        .O(\axi_araddr[4]_i_1_n_0 ));
  FDRE \axi_araddr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_araddr[2]_i_1_n_0 ),
        .Q(axi_araddr[2]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_araddr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_araddr[3]_i_1_n_0 ),
        .Q(axi_araddr[3]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_araddr_reg[4] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_araddr[4]_i_1_n_0 ),
        .Q(axi_araddr[4]),
        .R(s00_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h2)) 
    axi_arready_i_1
       (.I0(s00_axi_arvalid),
        .I1(S_AXI_ARREADY),
        .O(axi_arready0));
  FDRE axi_arready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_arready0),
        .Q(S_AXI_ARREADY),
        .R(s00_axi_aresetn_0));
  LUT6 #(
    .INIT(64'hEFFFFFFF20000000)) 
    \axi_awaddr[2]_i_1 
       (.I0(s00_axi_awaddr[0]),
        .I1(S_AXI_AWREADY),
        .I2(aw_en_reg_n_0),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_wvalid),
        .I5(p_0_in_0[0]),
        .O(\axi_awaddr[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hEFFFFFFF20000000)) 
    \axi_awaddr[3]_i_1 
       (.I0(s00_axi_awaddr[1]),
        .I1(S_AXI_AWREADY),
        .I2(aw_en_reg_n_0),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_wvalid),
        .I5(p_0_in_0[1]),
        .O(\axi_awaddr[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hEFFFFFFF20000000)) 
    \axi_awaddr[4]_i_1 
       (.I0(s00_axi_awaddr[2]),
        .I1(S_AXI_AWREADY),
        .I2(aw_en_reg_n_0),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_wvalid),
        .I5(p_0_in_0[2]),
        .O(\axi_awaddr[4]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_awaddr[2]_i_1_n_0 ),
        .Q(p_0_in_0[0]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_awaddr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_awaddr[3]_i_1_n_0 ),
        .Q(p_0_in_0[1]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_awaddr_reg[4] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_awaddr[4]_i_1_n_0 ),
        .Q(p_0_in_0[2]),
        .R(s00_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    axi_awready_i_1
       (.I0(S_AXI_AWREADY),
        .I1(aw_en_reg_n_0),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_wvalid),
        .O(axi_awready0));
  FDRE axi_awready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_awready0),
        .Q(S_AXI_AWREADY),
        .R(s00_axi_aresetn_0));
  LUT6 #(
    .INIT(64'h55555555C0000000)) 
    axi_bvalid_i_1
       (.I0(s00_axi_bready),
        .I1(s00_axi_wvalid),
        .I2(s00_axi_awvalid),
        .I3(S_AXI_AWREADY),
        .I4(S_AXI_WREADY),
        .I5(s00_axi_bvalid),
        .O(axi_bvalid_i_1_n_0));
  FDRE axi_bvalid_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_bvalid_i_1_n_0),
        .Q(s00_axi_bvalid),
        .R(s00_axi_aresetn_0));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[0]_i_3 
       (.I0(perph_i[0]),
        .I1(perph_i[8]),
        .I2(perph_i[24]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[16]),
        .O(\axi_rdata[0]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[0]_i_6 
       (.I0(slv_reg3[0]),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[0]),
        .O(\axi_rdata[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[10]_i_3 
       (.I0(perph_i[18]),
        .I1(perph_i[10]),
        .I2(perph_i[26]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[2]),
        .O(\axi_rdata[10]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[10]_i_6 
       (.I0(\slv_reg3_reg_n_0_[10] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[10]),
        .O(\axi_rdata[10]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[11]_i_3 
       (.I0(perph_i[11]),
        .I1(perph_i[19]),
        .I2(perph_i[3]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[27]),
        .O(\axi_rdata[11]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[11]_i_6 
       (.I0(\slv_reg3_reg_n_0_[11] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[11]),
        .O(\axi_rdata[11]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[12]_i_3 
       (.I0(perph_i[12]),
        .I1(perph_i[20]),
        .I2(perph_i[4]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[28]),
        .O(\axi_rdata[12]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[12]_i_6 
       (.I0(\slv_reg3_reg_n_0_[12] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[12]),
        .O(\axi_rdata[12]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[13]_i_3 
       (.I0(perph_i[21]),
        .I1(perph_i[13]),
        .I2(perph_i[29]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[5]),
        .O(\axi_rdata[13]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[13]_i_6 
       (.I0(\slv_reg3_reg_n_0_[13] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[13]),
        .O(\axi_rdata[13]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[14]_i_3 
       (.I0(perph_i[22]),
        .I1(perph_i[14]),
        .I2(perph_i[30]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[6]),
        .O(\axi_rdata[14]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[14]_i_6 
       (.I0(\slv_reg3_reg_n_0_[14] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[14]),
        .O(\axi_rdata[14]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[15]_i_3 
       (.I0(perph_i[23]),
        .I1(perph_i[15]),
        .I2(perph_i[31]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[7]),
        .O(\axi_rdata[15]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[15]_i_6 
       (.I0(\slv_reg3_reg_n_0_[15] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[15]),
        .O(\axi_rdata[15]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0055330FFF5533)) 
    \axi_rdata[16]_i_3 
       (.I0(perph_i[24]),
        .I1(perph_i[16]),
        .I2(perph_i[8]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[0]),
        .O(\axi_rdata[16]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[16]_i_6 
       (.I0(\slv_reg3_reg_n_0_[16] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[16]),
        .O(\axi_rdata[16]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[17]_i_3 
       (.I0(perph_i[17]),
        .I1(perph_i[25]),
        .I2(perph_i[9]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[1]),
        .O(\axi_rdata[17]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[17]_i_6 
       (.I0(\slv_reg3_reg_n_0_[17] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[17]),
        .O(\axi_rdata[17]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0055330FFF5533)) 
    \axi_rdata[18]_i_3 
       (.I0(perph_i[26]),
        .I1(perph_i[18]),
        .I2(perph_i[10]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[2]),
        .O(\axi_rdata[18]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[18]_i_6 
       (.I0(\slv_reg3_reg_n_0_[18] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[18]),
        .O(\axi_rdata[18]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[19]_i_3 
       (.I0(perph_i[27]),
        .I1(perph_i[19]),
        .I2(perph_i[3]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[11]),
        .O(\axi_rdata[19]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[19]_i_6 
       (.I0(\slv_reg3_reg_n_0_[19] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[19]),
        .O(\axi_rdata[19]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0055330FFF5533)) 
    \axi_rdata[1]_i_3 
       (.I0(perph_i[9]),
        .I1(perph_i[1]),
        .I2(perph_i[25]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[17]),
        .O(\axi_rdata[1]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[1]_i_6 
       (.I0(slv_reg3[1]),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[1]),
        .O(\axi_rdata[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[20]_i_3 
       (.I0(perph_i[20]),
        .I1(perph_i[28]),
        .I2(perph_i[12]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[4]),
        .O(\axi_rdata[20]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[20]_i_6 
       (.I0(\slv_reg3_reg_n_0_[20] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[20]),
        .O(\axi_rdata[20]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[21]_i_3 
       (.I0(perph_i[29]),
        .I1(perph_i[21]),
        .I2(perph_i[5]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[13]),
        .O(\axi_rdata[21]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[21]_i_6 
       (.I0(\slv_reg3_reg_n_0_[21] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[21]),
        .O(\axi_rdata[21]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[22]_i_3 
       (.I0(perph_i[22]),
        .I1(perph_i[30]),
        .I2(perph_i[14]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[6]),
        .O(\axi_rdata[22]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[22]_i_6 
       (.I0(\slv_reg3_reg_n_0_[22] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[22]),
        .O(\axi_rdata[22]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0055330FFF5533)) 
    \axi_rdata[23]_i_3 
       (.I0(perph_i[31]),
        .I1(perph_i[23]),
        .I2(perph_i[15]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[7]),
        .O(\axi_rdata[23]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[23]_i_6 
       (.I0(\slv_reg3_reg_n_0_[23] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[23]),
        .O(\axi_rdata[23]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[24]_i_3 
       (.I0(perph_i[0]),
        .I1(perph_i[24]),
        .I2(perph_i[8]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[16]),
        .O(\axi_rdata[24]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[24]_i_6 
       (.I0(\slv_reg3_reg_n_0_[24] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[24]),
        .O(\axi_rdata[24]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h5533000F5533FF0F)) 
    \axi_rdata[25]_i_3 
       (.I0(perph_i[17]),
        .I1(perph_i[9]),
        .I2(perph_i[25]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[1]),
        .O(\axi_rdata[25]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[25]_i_6 
       (.I0(\slv_reg3_reg_n_0_[25] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[25]),
        .O(\axi_rdata[25]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0055330FFF5533)) 
    \axi_rdata[26]_i_3 
       (.I0(perph_i[2]),
        .I1(perph_i[26]),
        .I2(perph_i[18]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[10]),
        .O(\axi_rdata[26]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[26]_i_6 
       (.I0(\slv_reg3_reg_n_0_[26] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[26]),
        .O(\axi_rdata[26]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[27]_i_3 
       (.I0(perph_i[27]),
        .I1(perph_i[3]),
        .I2(perph_i[19]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[11]),
        .O(\axi_rdata[27]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[27]_i_6 
       (.I0(\slv_reg3_reg_n_0_[27] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[27]),
        .O(\axi_rdata[27]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[28]_i_3 
       (.I0(perph_i[4]),
        .I1(perph_i[28]),
        .I2(perph_i[12]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[20]),
        .O(\axi_rdata[28]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[28]_i_6 
       (.I0(\slv_reg3_reg_n_0_[28] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[28]),
        .O(\axi_rdata[28]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[29]_i_3 
       (.I0(perph_i[5]),
        .I1(perph_i[29]),
        .I2(perph_i[13]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[21]),
        .O(\axi_rdata[29]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[29]_i_6 
       (.I0(\slv_reg3_reg_n_0_[29] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[29]),
        .O(\axi_rdata[29]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0055330FFF5533)) 
    \axi_rdata[2]_i_3 
       (.I0(perph_i[10]),
        .I1(perph_i[2]),
        .I2(perph_i[26]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[18]),
        .O(\axi_rdata[2]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[2]_i_6 
       (.I0(\slv_reg3_reg_n_0_[2] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[2]),
        .O(\axi_rdata[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[30]_i_3 
       (.I0(perph_i[6]),
        .I1(perph_i[30]),
        .I2(perph_i[14]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[22]),
        .O(\axi_rdata[30]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[30]_i_6 
       (.I0(\slv_reg3_reg_n_0_[30] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[30]),
        .O(\axi_rdata[30]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \axi_rdata[31]_i_3 
       (.I0(axi_araddr[2]),
        .I1(axi_araddr[3]),
        .O(\axi_rdata[31]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[31]_i_4 
       (.I0(perph_i[7]),
        .I1(perph_i[31]),
        .I2(perph_i[15]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[23]),
        .O(\axi_rdata[31]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[31]_i_7 
       (.I0(\slv_reg3_reg_n_0_[31] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[31]),
        .O(\axi_rdata[31]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[3]_i_3 
       (.I0(perph_i[11]),
        .I1(perph_i[3]),
        .I2(perph_i[19]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[27]),
        .O(\axi_rdata[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[4]_i_3 
       (.I0(perph_i[12]),
        .I1(perph_i[4]),
        .I2(perph_i[20]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[28]),
        .O(\axi_rdata[4]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[4]_i_6 
       (.I0(\slv_reg3_reg_n_0_[4] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[4]),
        .O(\axi_rdata[4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0055330FFF5533)) 
    \axi_rdata[5]_i_3 
       (.I0(perph_i[13]),
        .I1(perph_i[5]),
        .I2(perph_i[29]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[21]),
        .O(\axi_rdata[5]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[5]_i_6 
       (.I0(\slv_reg3_reg_n_0_[5] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[5]),
        .O(\axi_rdata[5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[6]_i_3 
       (.I0(perph_i[6]),
        .I1(perph_i[14]),
        .I2(perph_i[30]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[22]),
        .O(\axi_rdata[6]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[6]_i_6 
       (.I0(\slv_reg3_reg_n_0_[6] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[6]),
        .O(\axi_rdata[6]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0F0055330FFF5533)) 
    \axi_rdata[7]_i_3 
       (.I0(perph_i[15]),
        .I1(perph_i[7]),
        .I2(perph_i[31]),
        .I3(bram_addr_a[0]),
        .I4(bram_addr_a[1]),
        .I5(perph_i[23]),
        .O(\axi_rdata[7]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[7]_i_6 
       (.I0(\slv_reg3_reg_n_0_[7] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[7]),
        .O(\axi_rdata[7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[8]_i_3 
       (.I0(perph_i[16]),
        .I1(perph_i[8]),
        .I2(perph_i[24]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[0]),
        .O(\axi_rdata[8]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[8]_i_6 
       (.I0(\slv_reg3_reg_n_0_[8] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[8]),
        .O(\axi_rdata[8]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[9]_i_3 
       (.I0(perph_i[17]),
        .I1(perph_i[9]),
        .I2(perph_i[25]),
        .I3(bram_addr_a[1]),
        .I4(bram_addr_a[0]),
        .I5(perph_i[1]),
        .O(\axi_rdata[9]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8380)) 
    \axi_rdata[9]_i_6 
       (.I0(\slv_reg3_reg_n_0_[9] ),
        .I1(axi_araddr[3]),
        .I2(axi_araddr[2]),
        .I3(bram_addr_a[9]),
        .O(\axi_rdata[9]_i_6_n_0 ));
  FDRE \axi_rdata_reg[0] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_31),
        .Q(s00_axi_rdata[0]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[10] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_21),
        .Q(s00_axi_rdata[10]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[11] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_20),
        .Q(s00_axi_rdata[11]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[12] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_19),
        .Q(s00_axi_rdata[12]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[13] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_18),
        .Q(s00_axi_rdata[13]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[14] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_17),
        .Q(s00_axi_rdata[14]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[15] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_16),
        .Q(s00_axi_rdata[15]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[16] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_15),
        .Q(s00_axi_rdata[16]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[17] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_14),
        .Q(s00_axi_rdata[17]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[18] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_13),
        .Q(s00_axi_rdata[18]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[19] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_12),
        .Q(s00_axi_rdata[19]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[1] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_30),
        .Q(s00_axi_rdata[1]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[20] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_11),
        .Q(s00_axi_rdata[20]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[21] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_10),
        .Q(s00_axi_rdata[21]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[22] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_9),
        .Q(s00_axi_rdata[22]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[23] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_8),
        .Q(s00_axi_rdata[23]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[24] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_7),
        .Q(s00_axi_rdata[24]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[25] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_6),
        .Q(s00_axi_rdata[25]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[26] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_5),
        .Q(s00_axi_rdata[26]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[27] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_4),
        .Q(s00_axi_rdata[27]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[28] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_3),
        .Q(s00_axi_rdata[28]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[29] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_2),
        .Q(s00_axi_rdata[29]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[2] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_29),
        .Q(s00_axi_rdata[2]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[30] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_1),
        .Q(s00_axi_rdata[30]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[31] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_0),
        .Q(s00_axi_rdata[31]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[3] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_28),
        .Q(s00_axi_rdata[3]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[4] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_27),
        .Q(s00_axi_rdata[4]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[5] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_26),
        .Q(s00_axi_rdata[5]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[6] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_25),
        .Q(s00_axi_rdata[6]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[7] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_24),
        .Q(s00_axi_rdata[7]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[8] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_23),
        .Q(s00_axi_rdata[8]),
        .R(s00_axi_aresetn_0));
  FDRE \axi_rdata_reg[9] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(Platform_IO_inst_n_22),
        .Q(s00_axi_rdata[9]),
        .R(s00_axi_aresetn_0));
  LUT4 #(
    .INIT(16'h08F8)) 
    axi_rvalid_i_1
       (.I0(S_AXI_ARREADY),
        .I1(s00_axi_arvalid),
        .I2(s00_axi_rvalid),
        .I3(s00_axi_rready),
        .O(axi_rvalid_i_1_n_0));
  FDRE axi_rvalid_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_rvalid_i_1_n_0),
        .Q(s00_axi_rvalid),
        .R(s00_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    axi_wready_i_1
       (.I0(S_AXI_WREADY),
        .I1(aw_en_reg_n_0),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_wvalid),
        .O(axi_wready0));
  FDRE axi_wready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_wready0),
        .Q(S_AXI_WREADY),
        .R(s00_axi_aresetn_0));
  LUT3 #(
    .INIT(8'hB8)) 
    bram_clk_a_INST_0
       (.I0(slv_reg3[1]),
        .I1(slv_reg3[0]),
        .I2(s00_axi_aclk),
        .O(clk_o));
  LUT6 #(
    .INIT(64'h0000002000000000)) 
    bram_we_a_INST_0
       (.I0(bram_en_a),
        .I1(Platform_IO_inst_n_32),
        .I2(s00_axi_wstrb[0]),
        .I3(p_0_in_0[1]),
        .I4(p_0_in_0[2]),
        .I5(p_0_in_0[0]),
        .O(bram_we_a));
  LUT5 #(
    .INIT(32'h00000100)) 
    \slv_reg0[11]_i_1 
       (.I0(p_0_in_0[2]),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[0]),
        .I3(s00_axi_wstrb[1]),
        .I4(Platform_IO_inst_n_32),
        .O(\slv_reg0[11]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000100)) 
    \slv_reg0[23]_i_1 
       (.I0(p_0_in_0[2]),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[0]),
        .I3(s00_axi_wstrb[2]),
        .I4(Platform_IO_inst_n_32),
        .O(\slv_reg0[23]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000004)) 
    \slv_reg0[31]_i_1 
       (.I0(Platform_IO_inst_n_32),
        .I1(s00_axi_wstrb[3]),
        .I2(p_0_in_0[2]),
        .I3(p_0_in_0[1]),
        .I4(p_0_in_0[0]),
        .O(\slv_reg0[31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000100)) 
    \slv_reg0[7]_i_1 
       (.I0(p_0_in_0[2]),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[0]),
        .I3(s00_axi_wstrb[0]),
        .I4(Platform_IO_inst_n_32),
        .O(\slv_reg0[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(bram_addr_a[0]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[11]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(bram_addr_a[10]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[11]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(bram_addr_a[11]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[11]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg0[12]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[11]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg0[13]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[11]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg0[14]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[11]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg0[15]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg0[16]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg0[17]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg0[18]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg0[19]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(bram_addr_a[1]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg0[20]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg0[21]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg0[22]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg0[23]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg0[24]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg0[25]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg0[26]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg0[27]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg0[28]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg0[29]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(bram_addr_a[2]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg0[30]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg0[31]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(bram_addr_a[3]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(bram_addr_a[4]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(bram_addr_a[5]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(bram_addr_a[6]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(bram_addr_a[7]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[11]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(bram_addr_a[8]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg0_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[11]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(bram_addr_a[9]),
        .R(s00_axi_aresetn_0));
  LUT5 #(
    .INIT(32'h00004000)) 
    \slv_reg3[15]_i_1 
       (.I0(p_0_in_0[2]),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[0]),
        .I3(s00_axi_wstrb[1]),
        .I4(Platform_IO_inst_n_32),
        .O(\slv_reg3[15]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00004000)) 
    \slv_reg3[23]_i_1 
       (.I0(p_0_in_0[2]),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[0]),
        .I3(s00_axi_wstrb[2]),
        .I4(Platform_IO_inst_n_32),
        .O(\slv_reg3[23]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00400000)) 
    \slv_reg3[31]_i_1 
       (.I0(p_0_in_0[2]),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[0]),
        .I3(Platform_IO_inst_n_32),
        .I4(s00_axi_wstrb[3]),
        .O(\slv_reg3[31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00004000)) 
    \slv_reg3[3]_i_1 
       (.I0(p_0_in_0[2]),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[0]),
        .I3(s00_axi_wstrb[0]),
        .I4(Platform_IO_inst_n_32),
        .O(\slv_reg3[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \slv_reg3[4]_i_1 
       (.I0(\slv_reg3[4]_i_2_n_0 ),
        .I1(s00_axi_aresetn),
        .I2(S_AXI_WREADY),
        .I3(S_AXI_AWREADY),
        .I4(s00_axi_awvalid),
        .I5(s00_axi_wvalid),
        .O(\slv_reg3[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888888888888888)) 
    \slv_reg3[4]_i_2 
       (.I0(\slv_reg3_reg_n_0_[4] ),
        .I1(p_0_in_0[2]),
        .I2(p_0_in_0[0]),
        .I3(p_0_in_0[1]),
        .I4(s00_axi_wdata[4]),
        .I5(s00_axi_wstrb[0]),
        .O(\slv_reg3[4]_i_2_n_0 ));
  FDRE \slv_reg3_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[3]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg3[0]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(\slv_reg3_reg_n_0_[10] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(\slv_reg3_reg_n_0_[11] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(\slv_reg3_reg_n_0_[12] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(\slv_reg3_reg_n_0_[13] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(\slv_reg3_reg_n_0_[14] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(\slv_reg3_reg_n_0_[15] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(\slv_reg3_reg_n_0_[16] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(\slv_reg3_reg_n_0_[17] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(\slv_reg3_reg_n_0_[18] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(\slv_reg3_reg_n_0_[19] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[3]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg3[1]),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(\slv_reg3_reg_n_0_[20] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(\slv_reg3_reg_n_0_[21] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(\slv_reg3_reg_n_0_[22] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(\slv_reg3_reg_n_0_[23] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(\slv_reg3_reg_n_0_[24] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(\slv_reg3_reg_n_0_[25] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(\slv_reg3_reg_n_0_[26] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(\slv_reg3_reg_n_0_[27] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(\slv_reg3_reg_n_0_[28] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(\slv_reg3_reg_n_0_[29] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[3]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(\slv_reg3_reg_n_0_[2] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(\slv_reg3_reg_n_0_[30] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(\slv_reg3_reg_n_0_[31] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[3]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(bram_en_a),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[4] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\slv_reg3[4]_i_1_n_0 ),
        .Q(\slv_reg3_reg_n_0_[4] ),
        .R(1'b0));
  FDRE \slv_reg3_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[3]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(\slv_reg3_reg_n_0_[5] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[3]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(\slv_reg3_reg_n_0_[6] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[3]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(\slv_reg3_reg_n_0_[7] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(\slv_reg3_reg_n_0_[8] ),
        .R(s00_axi_aresetn_0));
  FDRE \slv_reg3_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(\slv_reg3_reg_n_0_[9] ),
        .R(s00_axi_aresetn_0));
  LUT3 #(
    .INIT(8'h20)) 
    slv_reg_rden
       (.I0(s00_axi_arvalid),
        .I1(s00_axi_rvalid),
        .I2(S_AXI_ARREADY),
        .O(slv_reg_rden__0));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Platform_IO
   (D,
    s00_axi_wvalid_0,
    \write_buffer_reg[2][7]_0 ,
    \write_buffer_reg[3][7]_0 ,
    \write_buffer_reg[0][7]_0 ,
    \write_buffer_reg[1][7]_0 ,
    SR,
    \write_buffer_reg[0][0]_0 ,
    \write_buffer_reg[0][0]_1 ,
    s00_axi_awvalid,
    s00_axi_wvalid,
    s00_axi_wstrb,
    p_0_in_0,
    axi_araddr,
    \axi_rdata_reg[0] ,
    \axi_rdata_reg[0]_0 ,
    \axi_rdata_reg[0]_1 ,
    \axi_rdata_reg[6] ,
    \axi_rdata_reg[19] ,
    \axi_rdata_reg[11] ,
    \axi_rdata_reg[12] ,
    \axi_rdata_reg[17] ,
    \axi_rdata_reg[27] ,
    \axi_rdata_reg[20] ,
    \axi_rdata_reg[21] ,
    \axi_rdata_reg[22] ,
    \axi_rdata_reg[23] ,
    \axi_rdata_reg[1] ,
    \axi_rdata_reg[2] ,
    \axi_rdata_reg[3] ,
    \axi_rdata_reg[4] ,
    \axi_rdata_reg[5] ,
    \axi_rdata_reg[7] ,
    \axi_rdata_reg[8] ,
    \axi_rdata_reg[9] ,
    \axi_rdata_reg[10] ,
    \axi_rdata_reg[13] ,
    \axi_rdata_reg[14] ,
    \axi_rdata_reg[15] ,
    \axi_rdata_reg[16] ,
    \axi_rdata_reg[18] ,
    \axi_rdata_reg[24] ,
    \axi_rdata_reg[25] ,
    \axi_rdata_reg[26] ,
    \axi_rdata_reg[28] ,
    \axi_rdata_reg[29] ,
    \axi_rdata_reg[30] ,
    \axi_rdata_reg[31] ,
    Q,
    \write_buffer_reg[0][0]_2 ,
    s00_axi_wdata,
    bram_rddata_a,
    \axi_rdata_reg[0]_2 ,
    \axi_rdata_reg[1]_0 ,
    \axi_rdata_reg[2]_0 ,
    \axi_rdata_reg[4]_0 ,
    \axi_rdata_reg[5]_0 ,
    \axi_rdata_reg[6]_0 ,
    \axi_rdata_reg[7]_0 ,
    \axi_rdata_reg[8]_0 ,
    \axi_rdata_reg[9]_0 ,
    \axi_rdata_reg[10]_0 ,
    \axi_rdata_reg[11]_0 ,
    \axi_rdata_reg[12]_0 ,
    \axi_rdata_reg[13]_0 ,
    \axi_rdata_reg[14]_0 ,
    \axi_rdata_reg[15]_0 ,
    \axi_rdata_reg[16]_0 ,
    \axi_rdata_reg[17]_0 ,
    \axi_rdata_reg[18]_0 ,
    \axi_rdata_reg[19]_0 ,
    \axi_rdata_reg[20]_0 ,
    \axi_rdata_reg[21]_0 ,
    \axi_rdata_reg[22]_0 ,
    \axi_rdata_reg[23]_0 ,
    \axi_rdata_reg[24]_0 ,
    \axi_rdata_reg[25]_0 ,
    \axi_rdata_reg[26]_0 ,
    \axi_rdata_reg[27]_0 ,
    \axi_rdata_reg[28]_0 ,
    \axi_rdata_reg[29]_0 ,
    \axi_rdata_reg[30]_0 ,
    \axi_rdata_reg[31]_0 ,
    s00_axi_aresetn,
    s00_axi_aclk,
    perph_i);
  output [31:0]D;
  output s00_axi_wvalid_0;
  output [7:0]\write_buffer_reg[2][7]_0 ;
  output [7:0]\write_buffer_reg[3][7]_0 ;
  output [7:0]\write_buffer_reg[0][7]_0 ;
  output [7:0]\write_buffer_reg[1][7]_0 ;
  output [0:0]SR;
  input \write_buffer_reg[0][0]_0 ;
  input \write_buffer_reg[0][0]_1 ;
  input s00_axi_awvalid;
  input s00_axi_wvalid;
  input [3:0]s00_axi_wstrb;
  input [2:0]p_0_in_0;
  input [2:0]axi_araddr;
  input \axi_rdata_reg[0] ;
  input \axi_rdata_reg[0]_0 ;
  input \axi_rdata_reg[0]_1 ;
  input \axi_rdata_reg[6] ;
  input \axi_rdata_reg[19] ;
  input \axi_rdata_reg[11] ;
  input \axi_rdata_reg[12] ;
  input \axi_rdata_reg[17] ;
  input \axi_rdata_reg[27] ;
  input \axi_rdata_reg[20] ;
  input \axi_rdata_reg[21] ;
  input \axi_rdata_reg[22] ;
  input \axi_rdata_reg[23] ;
  input \axi_rdata_reg[1] ;
  input \axi_rdata_reg[2] ;
  input \axi_rdata_reg[3] ;
  input \axi_rdata_reg[4] ;
  input \axi_rdata_reg[5] ;
  input \axi_rdata_reg[7] ;
  input \axi_rdata_reg[8] ;
  input \axi_rdata_reg[9] ;
  input \axi_rdata_reg[10] ;
  input \axi_rdata_reg[13] ;
  input \axi_rdata_reg[14] ;
  input \axi_rdata_reg[15] ;
  input \axi_rdata_reg[16] ;
  input \axi_rdata_reg[18] ;
  input \axi_rdata_reg[24] ;
  input \axi_rdata_reg[25] ;
  input \axi_rdata_reg[26] ;
  input \axi_rdata_reg[28] ;
  input \axi_rdata_reg[29] ;
  input \axi_rdata_reg[30] ;
  input \axi_rdata_reg[31] ;
  input [2:0]Q;
  input \write_buffer_reg[0][0]_2 ;
  input [31:0]s00_axi_wdata;
  input [31:0]bram_rddata_a;
  input \axi_rdata_reg[0]_2 ;
  input \axi_rdata_reg[1]_0 ;
  input \axi_rdata_reg[2]_0 ;
  input \axi_rdata_reg[4]_0 ;
  input \axi_rdata_reg[5]_0 ;
  input \axi_rdata_reg[6]_0 ;
  input \axi_rdata_reg[7]_0 ;
  input \axi_rdata_reg[8]_0 ;
  input \axi_rdata_reg[9]_0 ;
  input \axi_rdata_reg[10]_0 ;
  input \axi_rdata_reg[11]_0 ;
  input \axi_rdata_reg[12]_0 ;
  input \axi_rdata_reg[13]_0 ;
  input \axi_rdata_reg[14]_0 ;
  input \axi_rdata_reg[15]_0 ;
  input \axi_rdata_reg[16]_0 ;
  input \axi_rdata_reg[17]_0 ;
  input \axi_rdata_reg[18]_0 ;
  input \axi_rdata_reg[19]_0 ;
  input \axi_rdata_reg[20]_0 ;
  input \axi_rdata_reg[21]_0 ;
  input \axi_rdata_reg[22]_0 ;
  input \axi_rdata_reg[23]_0 ;
  input \axi_rdata_reg[24]_0 ;
  input \axi_rdata_reg[25]_0 ;
  input \axi_rdata_reg[26]_0 ;
  input \axi_rdata_reg[27]_0 ;
  input \axi_rdata_reg[28]_0 ;
  input \axi_rdata_reg[29]_0 ;
  input \axi_rdata_reg[30]_0 ;
  input \axi_rdata_reg[31]_0 ;
  input s00_axi_aresetn;
  input s00_axi_aclk;
  input [31:0]perph_i;

  wire [31:0]D;
  wire [2:0]Q;
  wire [0:0]SR;
  wire [2:0]axi_araddr;
  wire \axi_rdata[0]_i_2_n_0 ;
  wire \axi_rdata[0]_i_4_n_0 ;
  wire \axi_rdata[0]_i_5_n_0 ;
  wire \axi_rdata[10]_i_2_n_0 ;
  wire \axi_rdata[10]_i_4_n_0 ;
  wire \axi_rdata[10]_i_5_n_0 ;
  wire \axi_rdata[11]_i_2_n_0 ;
  wire \axi_rdata[11]_i_4_n_0 ;
  wire \axi_rdata[11]_i_5_n_0 ;
  wire \axi_rdata[12]_i_2_n_0 ;
  wire \axi_rdata[12]_i_4_n_0 ;
  wire \axi_rdata[12]_i_5_n_0 ;
  wire \axi_rdata[13]_i_2_n_0 ;
  wire \axi_rdata[13]_i_4_n_0 ;
  wire \axi_rdata[13]_i_5_n_0 ;
  wire \axi_rdata[14]_i_2_n_0 ;
  wire \axi_rdata[14]_i_4_n_0 ;
  wire \axi_rdata[14]_i_5_n_0 ;
  wire \axi_rdata[15]_i_2_n_0 ;
  wire \axi_rdata[15]_i_4_n_0 ;
  wire \axi_rdata[15]_i_5_n_0 ;
  wire \axi_rdata[16]_i_2_n_0 ;
  wire \axi_rdata[16]_i_4_n_0 ;
  wire \axi_rdata[16]_i_5_n_0 ;
  wire \axi_rdata[17]_i_2_n_0 ;
  wire \axi_rdata[17]_i_4_n_0 ;
  wire \axi_rdata[17]_i_5_n_0 ;
  wire \axi_rdata[18]_i_2_n_0 ;
  wire \axi_rdata[18]_i_4_n_0 ;
  wire \axi_rdata[18]_i_5_n_0 ;
  wire \axi_rdata[19]_i_2_n_0 ;
  wire \axi_rdata[19]_i_4_n_0 ;
  wire \axi_rdata[19]_i_5_n_0 ;
  wire \axi_rdata[1]_i_2_n_0 ;
  wire \axi_rdata[1]_i_4_n_0 ;
  wire \axi_rdata[1]_i_5_n_0 ;
  wire \axi_rdata[20]_i_2_n_0 ;
  wire \axi_rdata[20]_i_4_n_0 ;
  wire \axi_rdata[20]_i_5_n_0 ;
  wire \axi_rdata[21]_i_2_n_0 ;
  wire \axi_rdata[21]_i_4_n_0 ;
  wire \axi_rdata[21]_i_5_n_0 ;
  wire \axi_rdata[22]_i_2_n_0 ;
  wire \axi_rdata[22]_i_4_n_0 ;
  wire \axi_rdata[22]_i_5_n_0 ;
  wire \axi_rdata[23]_i_2_n_0 ;
  wire \axi_rdata[23]_i_4_n_0 ;
  wire \axi_rdata[23]_i_5_n_0 ;
  wire \axi_rdata[24]_i_2_n_0 ;
  wire \axi_rdata[24]_i_4_n_0 ;
  wire \axi_rdata[24]_i_5_n_0 ;
  wire \axi_rdata[25]_i_2_n_0 ;
  wire \axi_rdata[25]_i_4_n_0 ;
  wire \axi_rdata[25]_i_5_n_0 ;
  wire \axi_rdata[26]_i_2_n_0 ;
  wire \axi_rdata[26]_i_4_n_0 ;
  wire \axi_rdata[26]_i_5_n_0 ;
  wire \axi_rdata[27]_i_2_n_0 ;
  wire \axi_rdata[27]_i_4_n_0 ;
  wire \axi_rdata[27]_i_5_n_0 ;
  wire \axi_rdata[28]_i_2_n_0 ;
  wire \axi_rdata[28]_i_4_n_0 ;
  wire \axi_rdata[28]_i_5_n_0 ;
  wire \axi_rdata[29]_i_2_n_0 ;
  wire \axi_rdata[29]_i_4_n_0 ;
  wire \axi_rdata[29]_i_5_n_0 ;
  wire \axi_rdata[2]_i_2_n_0 ;
  wire \axi_rdata[2]_i_4_n_0 ;
  wire \axi_rdata[2]_i_5_n_0 ;
  wire \axi_rdata[30]_i_2_n_0 ;
  wire \axi_rdata[30]_i_4_n_0 ;
  wire \axi_rdata[30]_i_5_n_0 ;
  wire \axi_rdata[31]_i_2_n_0 ;
  wire \axi_rdata[31]_i_5_n_0 ;
  wire \axi_rdata[31]_i_6_n_0 ;
  wire \axi_rdata[3]_i_2_n_0 ;
  wire \axi_rdata[3]_i_4_n_0 ;
  wire \axi_rdata[3]_i_5_n_0 ;
  wire \axi_rdata[4]_i_2_n_0 ;
  wire \axi_rdata[4]_i_4_n_0 ;
  wire \axi_rdata[4]_i_5_n_0 ;
  wire \axi_rdata[5]_i_2_n_0 ;
  wire \axi_rdata[5]_i_4_n_0 ;
  wire \axi_rdata[5]_i_5_n_0 ;
  wire \axi_rdata[6]_i_2_n_0 ;
  wire \axi_rdata[6]_i_4_n_0 ;
  wire \axi_rdata[6]_i_5_n_0 ;
  wire \axi_rdata[7]_i_2_n_0 ;
  wire \axi_rdata[7]_i_4_n_0 ;
  wire \axi_rdata[7]_i_5_n_0 ;
  wire \axi_rdata[8]_i_2_n_0 ;
  wire \axi_rdata[8]_i_4_n_0 ;
  wire \axi_rdata[8]_i_5_n_0 ;
  wire \axi_rdata[9]_i_2_n_0 ;
  wire \axi_rdata[9]_i_4_n_0 ;
  wire \axi_rdata[9]_i_5_n_0 ;
  wire \axi_rdata_reg[0] ;
  wire \axi_rdata_reg[0]_0 ;
  wire \axi_rdata_reg[0]_1 ;
  wire \axi_rdata_reg[0]_2 ;
  wire \axi_rdata_reg[10] ;
  wire \axi_rdata_reg[10]_0 ;
  wire \axi_rdata_reg[11] ;
  wire \axi_rdata_reg[11]_0 ;
  wire \axi_rdata_reg[12] ;
  wire \axi_rdata_reg[12]_0 ;
  wire \axi_rdata_reg[13] ;
  wire \axi_rdata_reg[13]_0 ;
  wire \axi_rdata_reg[14] ;
  wire \axi_rdata_reg[14]_0 ;
  wire \axi_rdata_reg[15] ;
  wire \axi_rdata_reg[15]_0 ;
  wire \axi_rdata_reg[16] ;
  wire \axi_rdata_reg[16]_0 ;
  wire \axi_rdata_reg[17] ;
  wire \axi_rdata_reg[17]_0 ;
  wire \axi_rdata_reg[18] ;
  wire \axi_rdata_reg[18]_0 ;
  wire \axi_rdata_reg[19] ;
  wire \axi_rdata_reg[19]_0 ;
  wire \axi_rdata_reg[1] ;
  wire \axi_rdata_reg[1]_0 ;
  wire \axi_rdata_reg[20] ;
  wire \axi_rdata_reg[20]_0 ;
  wire \axi_rdata_reg[21] ;
  wire \axi_rdata_reg[21]_0 ;
  wire \axi_rdata_reg[22] ;
  wire \axi_rdata_reg[22]_0 ;
  wire \axi_rdata_reg[23] ;
  wire \axi_rdata_reg[23]_0 ;
  wire \axi_rdata_reg[24] ;
  wire \axi_rdata_reg[24]_0 ;
  wire \axi_rdata_reg[25] ;
  wire \axi_rdata_reg[25]_0 ;
  wire \axi_rdata_reg[26] ;
  wire \axi_rdata_reg[26]_0 ;
  wire \axi_rdata_reg[27] ;
  wire \axi_rdata_reg[27]_0 ;
  wire \axi_rdata_reg[28] ;
  wire \axi_rdata_reg[28]_0 ;
  wire \axi_rdata_reg[29] ;
  wire \axi_rdata_reg[29]_0 ;
  wire \axi_rdata_reg[2] ;
  wire \axi_rdata_reg[2]_0 ;
  wire \axi_rdata_reg[30] ;
  wire \axi_rdata_reg[30]_0 ;
  wire \axi_rdata_reg[31] ;
  wire \axi_rdata_reg[31]_0 ;
  wire \axi_rdata_reg[3] ;
  wire \axi_rdata_reg[4] ;
  wire \axi_rdata_reg[4]_0 ;
  wire \axi_rdata_reg[5] ;
  wire \axi_rdata_reg[5]_0 ;
  wire \axi_rdata_reg[6] ;
  wire \axi_rdata_reg[6]_0 ;
  wire \axi_rdata_reg[7] ;
  wire \axi_rdata_reg[7]_0 ;
  wire \axi_rdata_reg[8] ;
  wire \axi_rdata_reg[8]_0 ;
  wire \axi_rdata_reg[9] ;
  wire \axi_rdata_reg[9]_0 ;
  wire [31:0]bram_rddata_a;
  wire capture;
  wire [7:0]p_0_in;
  wire [2:0]p_0_in_0;
  wire [31:0]perph_i;
  wire [7:0]\read_buffer_reg[0] ;
  wire [7:0]\read_buffer_reg[1] ;
  wire [7:0]\read_buffer_reg[2] ;
  wire [7:0]\read_buffer_reg[3] ;
  wire s00_axi_aclk;
  wire s00_axi_aresetn;
  wire s00_axi_awvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire s00_axi_wvalid_0;
  wire write_buffer;
  wire \write_buffer[0][7]_i_1_n_0 ;
  wire \write_buffer[0][7]_i_2_n_0 ;
  wire \write_buffer[0][7]_i_3_n_0 ;
  wire \write_buffer[1][7]_i_1_n_0 ;
  wire \write_buffer[1][7]_i_3_n_0 ;
  wire \write_buffer[1][7]_i_4_n_0 ;
  wire \write_buffer[2][0]_i_1_n_0 ;
  wire \write_buffer[2][1]_i_1_n_0 ;
  wire \write_buffer[2][2]_i_1_n_0 ;
  wire \write_buffer[2][3]_i_1_n_0 ;
  wire \write_buffer[2][4]_i_1_n_0 ;
  wire \write_buffer[2][5]_i_1_n_0 ;
  wire \write_buffer[2][6]_i_1_n_0 ;
  wire \write_buffer[2][7]_i_1_n_0 ;
  wire \write_buffer[2][7]_i_2_n_0 ;
  wire \write_buffer[2][7]_i_3_n_0 ;
  wire \write_buffer[3][0]_i_1_n_0 ;
  wire \write_buffer[3][0]_i_2_n_0 ;
  wire \write_buffer[3][1]_i_1_n_0 ;
  wire \write_buffer[3][1]_i_2_n_0 ;
  wire \write_buffer[3][2]_i_1_n_0 ;
  wire \write_buffer[3][2]_i_2_n_0 ;
  wire \write_buffer[3][3]_i_1_n_0 ;
  wire \write_buffer[3][3]_i_2_n_0 ;
  wire \write_buffer[3][4]_i_1_n_0 ;
  wire \write_buffer[3][4]_i_2_n_0 ;
  wire \write_buffer[3][5]_i_1_n_0 ;
  wire \write_buffer[3][5]_i_2_n_0 ;
  wire \write_buffer[3][6]_i_1_n_0 ;
  wire \write_buffer[3][6]_i_2_n_0 ;
  wire \write_buffer[3][7]_i_2_n_0 ;
  wire \write_buffer[3][7]_i_3_n_0 ;
  wire \write_buffer[3][7]_i_4_n_0 ;
  wire \write_buffer[3][7]_i_5_n_0 ;
  wire \write_buffer[3][7]_i_6_n_0 ;
  wire \write_buffer[3][7]_i_7_n_0 ;
  wire \write_buffer[3][7]_i_8_n_0 ;
  wire \write_buffer[3][7]_i_9_n_0 ;
  wire \write_buffer_reg[0][0]_0 ;
  wire \write_buffer_reg[0][0]_1 ;
  wire \write_buffer_reg[0][0]_2 ;
  wire [7:0]\write_buffer_reg[0][7]_0 ;
  wire [7:0]\write_buffer_reg[1][7]_0 ;
  wire [7:0]\write_buffer_reg[2][7]_0 ;
  wire [7:0]\write_buffer_reg[3][7]_0 ;

  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[0]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[0]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[0]_0 ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[0]_i_4_n_0 ),
        .O(D[0]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[0]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[0]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[0]_i_5_n_0 ),
        .I5(\axi_rdata_reg[0]_2 ),
        .O(\axi_rdata[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3355000F3355FF0F)) 
    \axi_rdata[0]_i_4 
       (.I0(\read_buffer_reg[2] [0]),
        .I1(\read_buffer_reg[3] [0]),
        .I2(\read_buffer_reg[0] [0]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [0]),
        .O(\axi_rdata[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \axi_rdata[0]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [0]),
        .I1(\write_buffer_reg[3][7]_0 [0]),
        .I2(\write_buffer_reg[0][7]_0 [0]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [0]),
        .O(\axi_rdata[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[10]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[10]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[10] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[10]_i_4_n_0 ),
        .O(D[10]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[10]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[10]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[10]_i_5_n_0 ),
        .I5(\axi_rdata_reg[10]_0 ),
        .O(\axi_rdata[10]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F3355000F3355FF)) 
    \axi_rdata[10]_i_4 
       (.I0(\read_buffer_reg[2] [2]),
        .I1(\read_buffer_reg[3] [2]),
        .I2(\read_buffer_reg[0] [2]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [2]),
        .O(\axi_rdata[10]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCAAFFF0CCAA00)) 
    \axi_rdata[10]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [2]),
        .I1(\write_buffer_reg[3][7]_0 [2]),
        .I2(\write_buffer_reg[0][7]_0 [2]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [2]),
        .O(\axi_rdata[10]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[11]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[11]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[11] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[11]_i_4_n_0 ),
        .O(D[11]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[11]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[11]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[11]_i_5_n_0 ),
        .I5(\axi_rdata_reg[11]_0 ),
        .O(\axi_rdata[11]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F3355000F3355FF)) 
    \axi_rdata[11]_i_4 
       (.I0(\read_buffer_reg[2] [3]),
        .I1(\read_buffer_reg[3] [3]),
        .I2(\read_buffer_reg[0] [3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [3]),
        .O(\axi_rdata[11]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCAAFFF0CCAA00)) 
    \axi_rdata[11]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [3]),
        .I1(\write_buffer_reg[3][7]_0 [3]),
        .I2(\write_buffer_reg[0][7]_0 [3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [3]),
        .O(\axi_rdata[11]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[12]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[12]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[12] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[12]_i_4_n_0 ),
        .O(D[12]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[12]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[12]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[12]_i_5_n_0 ),
        .I5(\axi_rdata_reg[12]_0 ),
        .O(\axi_rdata[12]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F5533000F5533FF)) 
    \axi_rdata[12]_i_4 
       (.I0(\read_buffer_reg[3] [4]),
        .I1(\read_buffer_reg[2] [4]),
        .I2(\read_buffer_reg[0] [4]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [4]),
        .O(\axi_rdata[12]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCAAFFF0CCAA00)) 
    \axi_rdata[12]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [4]),
        .I1(\write_buffer_reg[3][7]_0 [4]),
        .I2(\write_buffer_reg[0][7]_0 [4]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [4]),
        .O(\axi_rdata[12]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[13]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[13]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[13] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[13]_i_4_n_0 ),
        .O(D[13]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[13]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[13]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[13]_i_5_n_0 ),
        .I5(\axi_rdata_reg[13]_0 ),
        .O(\axi_rdata[13]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F3355000F3355FF)) 
    \axi_rdata[13]_i_4 
       (.I0(\read_buffer_reg[2] [5]),
        .I1(\read_buffer_reg[3] [5]),
        .I2(\read_buffer_reg[0] [5]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [5]),
        .O(\axi_rdata[13]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCAAFFF0CCAA00)) 
    \axi_rdata[13]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [5]),
        .I1(\write_buffer_reg[3][7]_0 [5]),
        .I2(\write_buffer_reg[0][7]_0 [5]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [5]),
        .O(\axi_rdata[13]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[14]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[14]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[14] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[14]_i_4_n_0 ),
        .O(D[14]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[14]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[14]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[14]_i_5_n_0 ),
        .I5(\axi_rdata_reg[14]_0 ),
        .O(\axi_rdata[14]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F3355000F3355FF)) 
    \axi_rdata[14]_i_4 
       (.I0(\read_buffer_reg[2] [6]),
        .I1(\read_buffer_reg[3] [6]),
        .I2(\read_buffer_reg[0] [6]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [6]),
        .O(\axi_rdata[14]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCAAFFF0CCAA00)) 
    \axi_rdata[14]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [6]),
        .I1(\write_buffer_reg[3][7]_0 [6]),
        .I2(\write_buffer_reg[0][7]_0 [6]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [6]),
        .O(\axi_rdata[14]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[15]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[15]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[15] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[15]_i_4_n_0 ),
        .O(D[15]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[15]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[15]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[15]_i_5_n_0 ),
        .I5(\axi_rdata_reg[15]_0 ),
        .O(\axi_rdata[15]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F3355000F3355FF)) 
    \axi_rdata[15]_i_4 
       (.I0(\read_buffer_reg[2] [7]),
        .I1(\read_buffer_reg[3] [7]),
        .I2(\read_buffer_reg[0] [7]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [7]),
        .O(\axi_rdata[15]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCAAFFF0CCAA00)) 
    \axi_rdata[15]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [7]),
        .I1(\write_buffer_reg[3][7]_0 [7]),
        .I2(\write_buffer_reg[0][7]_0 [7]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [7]),
        .O(\axi_rdata[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[16]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[16]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[16] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[16]_i_4_n_0 ),
        .O(D[16]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[16]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[16]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[16]_i_5_n_0 ),
        .I5(\axi_rdata_reg[16]_0 ),
        .O(\axi_rdata[16]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[16]_i_4 
       (.I0(\read_buffer_reg[3] [0]),
        .I1(\read_buffer_reg[2] [0]),
        .I2(\read_buffer_reg[0] [0]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[1] [0]),
        .O(\axi_rdata[16]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFAAF0CC00AAF0CC)) 
    \axi_rdata[16]_i_5 
       (.I0(\write_buffer_reg[3][7]_0 [0]),
        .I1(\write_buffer_reg[2][7]_0 [0]),
        .I2(\write_buffer_reg[0][7]_0 [0]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\write_buffer_reg[1][7]_0 [0]),
        .O(\axi_rdata[16]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[17]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[17]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[17] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[17]_i_4_n_0 ),
        .O(D[17]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[17]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[17]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[17]_i_5_n_0 ),
        .I5(\axi_rdata_reg[17]_0 ),
        .O(\axi_rdata[17]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00330F55FF330F55)) 
    \axi_rdata[17]_i_4 
       (.I0(\read_buffer_reg[2] [1]),
        .I1(\read_buffer_reg[3] [1]),
        .I2(\read_buffer_reg[0] [1]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[1] [1]),
        .O(\axi_rdata[17]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCF0AA00CCF0AA)) 
    \axi_rdata[17]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [1]),
        .I1(\write_buffer_reg[3][7]_0 [1]),
        .I2(\write_buffer_reg[0][7]_0 [1]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\write_buffer_reg[1][7]_0 [1]),
        .O(\axi_rdata[17]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[18]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[18]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[18] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[18]_i_4_n_0 ),
        .O(D[18]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[18]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[18]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[18]_i_5_n_0 ),
        .I5(\axi_rdata_reg[18]_0 ),
        .O(\axi_rdata[18]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[18]_i_4 
       (.I0(\read_buffer_reg[3] [2]),
        .I1(\read_buffer_reg[2] [2]),
        .I2(\read_buffer_reg[0] [2]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[1] [2]),
        .O(\axi_rdata[18]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCF0AA00CCF0AA)) 
    \axi_rdata[18]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [2]),
        .I1(\write_buffer_reg[3][7]_0 [2]),
        .I2(\write_buffer_reg[0][7]_0 [2]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\write_buffer_reg[1][7]_0 [2]),
        .O(\axi_rdata[18]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[19]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[19]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[19] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[19]_i_4_n_0 ),
        .O(D[19]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[19]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[19]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[19]_i_5_n_0 ),
        .I5(\axi_rdata_reg[19]_0 ),
        .O(\axi_rdata[19]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00330F55FF330F55)) 
    \axi_rdata[19]_i_4 
       (.I0(\read_buffer_reg[2] [3]),
        .I1(\read_buffer_reg[3] [3]),
        .I2(\read_buffer_reg[0] [3]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[1] [3]),
        .O(\axi_rdata[19]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCF0AA00CCF0AA)) 
    \axi_rdata[19]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [3]),
        .I1(\write_buffer_reg[3][7]_0 [3]),
        .I2(\write_buffer_reg[0][7]_0 [3]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\write_buffer_reg[1][7]_0 [3]),
        .O(\axi_rdata[19]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[1]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[1]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[1] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[1]_i_4_n_0 ),
        .O(D[1]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[1]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[1]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[1]_i_5_n_0 ),
        .I5(\axi_rdata_reg[1]_0 ),
        .O(\axi_rdata[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3355000F3355FF0F)) 
    \axi_rdata[1]_i_4 
       (.I0(\read_buffer_reg[2] [1]),
        .I1(\read_buffer_reg[3] [1]),
        .I2(\read_buffer_reg[0] [1]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [1]),
        .O(\axi_rdata[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \axi_rdata[1]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [1]),
        .I1(\write_buffer_reg[3][7]_0 [1]),
        .I2(\write_buffer_reg[0][7]_0 [1]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [1]),
        .O(\axi_rdata[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[20]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[20]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[20] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[20]_i_4_n_0 ),
        .O(D[20]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[20]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[20]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[20]_i_5_n_0 ),
        .I5(\axi_rdata_reg[20]_0 ),
        .O(\axi_rdata[20]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00550F33FF550F33)) 
    \axi_rdata[20]_i_4 
       (.I0(\read_buffer_reg[3] [4]),
        .I1(\read_buffer_reg[2] [4]),
        .I2(\read_buffer_reg[0] [4]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[1] [4]),
        .O(\axi_rdata[20]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCF0AA00CCF0AA)) 
    \axi_rdata[20]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [4]),
        .I1(\write_buffer_reg[3][7]_0 [4]),
        .I2(\write_buffer_reg[0][7]_0 [4]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\write_buffer_reg[1][7]_0 [4]),
        .O(\axi_rdata[20]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[21]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[21]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[21] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[21]_i_4_n_0 ),
        .O(D[21]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[21]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[21]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[21]_i_5_n_0 ),
        .I5(\axi_rdata_reg[21]_0 ),
        .O(\axi_rdata[21]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00330F55FF330F55)) 
    \axi_rdata[21]_i_4 
       (.I0(\read_buffer_reg[2] [5]),
        .I1(\read_buffer_reg[3] [5]),
        .I2(\read_buffer_reg[0] [5]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[1] [5]),
        .O(\axi_rdata[21]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFAAF0CC00AAF0CC)) 
    \axi_rdata[21]_i_5 
       (.I0(\write_buffer_reg[3][7]_0 [5]),
        .I1(\write_buffer_reg[2][7]_0 [5]),
        .I2(\write_buffer_reg[0][7]_0 [5]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\write_buffer_reg[1][7]_0 [5]),
        .O(\axi_rdata[21]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[22]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[22]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[22] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[22]_i_4_n_0 ),
        .O(D[22]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[22]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[22]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[22]_i_5_n_0 ),
        .I5(\axi_rdata_reg[22]_0 ),
        .O(\axi_rdata[22]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00330F55FF330F55)) 
    \axi_rdata[22]_i_4 
       (.I0(\read_buffer_reg[2] [6]),
        .I1(\read_buffer_reg[3] [6]),
        .I2(\read_buffer_reg[0] [6]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[1] [6]),
        .O(\axi_rdata[22]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCF0AA00CCF0AA)) 
    \axi_rdata[22]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [6]),
        .I1(\write_buffer_reg[3][7]_0 [6]),
        .I2(\write_buffer_reg[0][7]_0 [6]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\write_buffer_reg[1][7]_0 [6]),
        .O(\axi_rdata[22]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[23]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[23]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[23] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[23]_i_4_n_0 ),
        .O(D[23]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[23]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[23]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[23]_i_5_n_0 ),
        .I5(\axi_rdata_reg[23]_0 ),
        .O(\axi_rdata[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F0033550FFF3355)) 
    \axi_rdata[23]_i_4 
       (.I0(\read_buffer_reg[2] [7]),
        .I1(\read_buffer_reg[3] [7]),
        .I2(\read_buffer_reg[1] [7]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[0] [7]),
        .O(\axi_rdata[23]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCF0AA00CCF0AA)) 
    \axi_rdata[23]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [7]),
        .I1(\write_buffer_reg[3][7]_0 [7]),
        .I2(\write_buffer_reg[0][7]_0 [7]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\write_buffer_reg[1][7]_0 [7]),
        .O(\axi_rdata[23]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[24]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[24]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[24] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[24]_i_4_n_0 ),
        .O(D[24]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[24]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[24]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[24]_i_5_n_0 ),
        .I5(\axi_rdata_reg[24]_0 ),
        .O(\axi_rdata[24]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h33000F5533FF0F55)) 
    \axi_rdata[24]_i_4 
       (.I0(\read_buffer_reg[3] [0]),
        .I1(\read_buffer_reg[2] [0]),
        .I2(\read_buffer_reg[0] [0]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [0]),
        .O(\axi_rdata[24]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \axi_rdata[24]_i_5 
       (.I0(\write_buffer_reg[3][7]_0 [0]),
        .I1(\write_buffer_reg[2][7]_0 [0]),
        .I2(\write_buffer_reg[0][7]_0 [0]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [0]),
        .O(\axi_rdata[24]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[25]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[25]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[25] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[25]_i_4_n_0 ),
        .O(D[25]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[25]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[25]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[25]_i_5_n_0 ),
        .I5(\axi_rdata_reg[25]_0 ),
        .O(\axi_rdata[25]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h55000F3355FF0F33)) 
    \axi_rdata[25]_i_4 
       (.I0(\read_buffer_reg[2] [1]),
        .I1(\read_buffer_reg[3] [1]),
        .I2(\read_buffer_reg[0] [1]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [1]),
        .O(\axi_rdata[25]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAFFF0CCAA00F0CC)) 
    \axi_rdata[25]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [1]),
        .I1(\write_buffer_reg[3][7]_0 [1]),
        .I2(\write_buffer_reg[0][7]_0 [1]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [1]),
        .O(\axi_rdata[25]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[26]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[26]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[26] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[26]_i_4_n_0 ),
        .O(D[26]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[26]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[26]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[26]_i_5_n_0 ),
        .I5(\axi_rdata_reg[26]_0 ),
        .O(\axi_rdata[26]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h55000F3355FF0F33)) 
    \axi_rdata[26]_i_4 
       (.I0(\read_buffer_reg[2] [2]),
        .I1(\read_buffer_reg[3] [2]),
        .I2(\read_buffer_reg[1] [2]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[0] [2]),
        .O(\axi_rdata[26]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAFFF0CCAA00F0CC)) 
    \axi_rdata[26]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [2]),
        .I1(\write_buffer_reg[3][7]_0 [2]),
        .I2(\write_buffer_reg[0][7]_0 [2]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [2]),
        .O(\axi_rdata[26]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[27]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[27]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[27] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[27]_i_4_n_0 ),
        .O(D[27]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[27]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[27]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[27]_i_5_n_0 ),
        .I5(\axi_rdata_reg[27]_0 ),
        .O(\axi_rdata[27]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h33000F5533FF0F55)) 
    \axi_rdata[27]_i_4 
       (.I0(\read_buffer_reg[3] [3]),
        .I1(\read_buffer_reg[2] [3]),
        .I2(\read_buffer_reg[0] [3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [3]),
        .O(\axi_rdata[27]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAFFF0CCAA00F0CC)) 
    \axi_rdata[27]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [3]),
        .I1(\write_buffer_reg[3][7]_0 [3]),
        .I2(\write_buffer_reg[0][7]_0 [3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [3]),
        .O(\axi_rdata[27]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[28]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[28]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[28] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[28]_i_4_n_0 ),
        .O(D[28]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[28]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[28]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[28]_i_5_n_0 ),
        .I5(\axi_rdata_reg[28]_0 ),
        .O(\axi_rdata[28]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h55000F3355FF0F33)) 
    \axi_rdata[28]_i_4 
       (.I0(\read_buffer_reg[2] [4]),
        .I1(\read_buffer_reg[3] [4]),
        .I2(\read_buffer_reg[1] [4]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(\read_buffer_reg[0] [4]),
        .O(\axi_rdata[28]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAFFF0CCAA00F0CC)) 
    \axi_rdata[28]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [4]),
        .I1(\write_buffer_reg[3][7]_0 [4]),
        .I2(\write_buffer_reg[0][7]_0 [4]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [4]),
        .O(\axi_rdata[28]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[29]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[29]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[29] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[29]_i_4_n_0 ),
        .O(D[29]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[29]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[29]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[29]_i_5_n_0 ),
        .I5(\axi_rdata_reg[29]_0 ),
        .O(\axi_rdata[29]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h55000F3355FF0F33)) 
    \axi_rdata[29]_i_4 
       (.I0(\read_buffer_reg[2] [5]),
        .I1(\read_buffer_reg[3] [5]),
        .I2(\read_buffer_reg[0] [5]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [5]),
        .O(\axi_rdata[29]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \axi_rdata[29]_i_5 
       (.I0(\write_buffer_reg[3][7]_0 [5]),
        .I1(\write_buffer_reg[2][7]_0 [5]),
        .I2(\write_buffer_reg[0][7]_0 [5]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [5]),
        .O(\axi_rdata[29]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[2]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[2]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[2] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[2]_i_4_n_0 ),
        .O(D[2]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[2]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[2]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[2]_i_5_n_0 ),
        .I5(\axi_rdata_reg[2]_0 ),
        .O(\axi_rdata[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h33550F0033550FFF)) 
    \axi_rdata[2]_i_4 
       (.I0(\read_buffer_reg[2] [2]),
        .I1(\read_buffer_reg[3] [2]),
        .I2(\read_buffer_reg[1] [2]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[0] [2]),
        .O(\axi_rdata[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \axi_rdata[2]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [2]),
        .I1(\write_buffer_reg[3][7]_0 [2]),
        .I2(\write_buffer_reg[0][7]_0 [2]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [2]),
        .O(\axi_rdata[2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[30]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[30]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[30] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[30]_i_4_n_0 ),
        .O(D[30]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[30]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[30]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[30]_i_5_n_0 ),
        .I5(\axi_rdata_reg[30]_0 ),
        .O(\axi_rdata[30]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h55000F3355FF0F33)) 
    \axi_rdata[30]_i_4 
       (.I0(\read_buffer_reg[2] [6]),
        .I1(\read_buffer_reg[3] [6]),
        .I2(\read_buffer_reg[0] [6]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [6]),
        .O(\axi_rdata[30]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAFFF0CCAA00F0CC)) 
    \axi_rdata[30]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [6]),
        .I1(\write_buffer_reg[3][7]_0 [6]),
        .I2(\write_buffer_reg[0][7]_0 [6]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [6]),
        .O(\axi_rdata[30]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[31]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[31]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[31] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[31]_i_5_n_0 ),
        .O(D[31]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[31]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[31]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[31]_i_6_n_0 ),
        .I5(\axi_rdata_reg[31]_0 ),
        .O(\axi_rdata[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h55000F3355FF0F33)) 
    \axi_rdata[31]_i_5 
       (.I0(\read_buffer_reg[2] [7]),
        .I1(\read_buffer_reg[3] [7]),
        .I2(\read_buffer_reg[0] [7]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [7]),
        .O(\axi_rdata[31]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \axi_rdata[31]_i_6 
       (.I0(\write_buffer_reg[3][7]_0 [7]),
        .I1(\write_buffer_reg[2][7]_0 [7]),
        .I2(\write_buffer_reg[0][7]_0 [7]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [7]),
        .O(\axi_rdata[31]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[3]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[3]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[3] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[3]_i_4_n_0 ),
        .O(D[3]));
  LUT6 #(
    .INIT(64'hFF00AAF00000CCF0)) 
    \axi_rdata[3]_i_2 
       (.I0(bram_rddata_a[3]),
        .I1(\axi_rdata[3]_i_5_n_0 ),
        .I2(Q[2]),
        .I3(axi_araddr[0]),
        .I4(axi_araddr[1]),
        .I5(\write_buffer_reg[0][0]_2 ),
        .O(\axi_rdata[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5533000F5533FF0F)) 
    \axi_rdata[3]_i_4 
       (.I0(\read_buffer_reg[3] [3]),
        .I1(\read_buffer_reg[2] [3]),
        .I2(\read_buffer_reg[0] [3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [3]),
        .O(\axi_rdata[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \axi_rdata[3]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [3]),
        .I1(\write_buffer_reg[3][7]_0 [3]),
        .I2(\write_buffer_reg[0][7]_0 [3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [3]),
        .O(\axi_rdata[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[4]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[4]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[4] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[4]_i_4_n_0 ),
        .O(D[4]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[4]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[4]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[4]_i_5_n_0 ),
        .I5(\axi_rdata_reg[4]_0 ),
        .O(\axi_rdata[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5533000F5533FF0F)) 
    \axi_rdata[4]_i_4 
       (.I0(\read_buffer_reg[3] [4]),
        .I1(\read_buffer_reg[2] [4]),
        .I2(\read_buffer_reg[0] [4]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [4]),
        .O(\axi_rdata[4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \axi_rdata[4]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [4]),
        .I1(\write_buffer_reg[3][7]_0 [4]),
        .I2(\write_buffer_reg[0][7]_0 [4]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [4]),
        .O(\axi_rdata[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[5]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[5]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[5] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[5]_i_4_n_0 ),
        .O(D[5]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[5]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[5]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[5]_i_5_n_0 ),
        .I5(\axi_rdata_reg[5]_0 ),
        .O(\axi_rdata[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3355000F3355FF0F)) 
    \axi_rdata[5]_i_4 
       (.I0(\read_buffer_reg[2] [5]),
        .I1(\read_buffer_reg[3] [5]),
        .I2(\read_buffer_reg[0] [5]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [5]),
        .O(\axi_rdata[5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAACCFFF0AACC00F0)) 
    \axi_rdata[5]_i_5 
       (.I0(\write_buffer_reg[3][7]_0 [5]),
        .I1(\write_buffer_reg[2][7]_0 [5]),
        .I2(\write_buffer_reg[0][7]_0 [5]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [5]),
        .O(\axi_rdata[5]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[6]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[6]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[6] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[6]_i_4_n_0 ),
        .O(D[6]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[6]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[6]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[6]_i_5_n_0 ),
        .I5(\axi_rdata_reg[6]_0 ),
        .O(\axi_rdata[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3355000F3355FF0F)) 
    \axi_rdata[6]_i_4 
       (.I0(\read_buffer_reg[2] [6]),
        .I1(\read_buffer_reg[3] [6]),
        .I2(\read_buffer_reg[0] [6]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [6]),
        .O(\axi_rdata[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \axi_rdata[6]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [6]),
        .I1(\write_buffer_reg[3][7]_0 [6]),
        .I2(\write_buffer_reg[0][7]_0 [6]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [6]),
        .O(\axi_rdata[6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[7]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[7]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[7] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[7]_i_4_n_0 ),
        .O(D[7]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[7]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[7]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[7]_i_5_n_0 ),
        .I5(\axi_rdata_reg[7]_0 ),
        .O(\axi_rdata[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h33550F0033550FFF)) 
    \axi_rdata[7]_i_4 
       (.I0(\read_buffer_reg[2] [7]),
        .I1(\read_buffer_reg[3] [7]),
        .I2(\read_buffer_reg[1] [7]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[0] [7]),
        .O(\axi_rdata[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \axi_rdata[7]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [7]),
        .I1(\write_buffer_reg[3][7]_0 [7]),
        .I2(\write_buffer_reg[0][7]_0 [7]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [7]),
        .O(\axi_rdata[7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[8]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[8]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[8] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[8]_i_4_n_0 ),
        .O(D[8]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[8]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[8]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[8]_i_5_n_0 ),
        .I5(\axi_rdata_reg[8]_0 ),
        .O(\axi_rdata[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F3355000F3355FF)) 
    \axi_rdata[8]_i_4 
       (.I0(\read_buffer_reg[2] [0]),
        .I1(\read_buffer_reg[3] [0]),
        .I2(\read_buffer_reg[0] [0]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [0]),
        .O(\axi_rdata[8]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0AACCFFF0AACC00)) 
    \axi_rdata[8]_i_5 
       (.I0(\write_buffer_reg[3][7]_0 [0]),
        .I1(\write_buffer_reg[2][7]_0 [0]),
        .I2(\write_buffer_reg[0][7]_0 [0]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [0]),
        .O(\axi_rdata[8]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444545454445)) 
    \axi_rdata[9]_i_1 
       (.I0(axi_araddr[2]),
        .I1(\axi_rdata[9]_i_2_n_0 ),
        .I2(\axi_rdata_reg[0] ),
        .I3(\axi_rdata_reg[9] ),
        .I4(\axi_rdata_reg[0]_1 ),
        .I5(\axi_rdata[9]_i_4_n_0 ),
        .O(D[9]));
  LUT6 #(
    .INIT(64'hFFFFFFFF20222000)) 
    \axi_rdata[9]_i_2 
       (.I0(axi_araddr[0]),
        .I1(axi_araddr[1]),
        .I2(bram_rddata_a[9]),
        .I3(\write_buffer_reg[0][0]_2 ),
        .I4(\axi_rdata[9]_i_5_n_0 ),
        .I5(\axi_rdata_reg[9]_0 ),
        .O(\axi_rdata[9]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F3355000F3355FF)) 
    \axi_rdata[9]_i_4 
       (.I0(\read_buffer_reg[2] [1]),
        .I1(\read_buffer_reg[3] [1]),
        .I2(\read_buffer_reg[0] [1]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\read_buffer_reg[1] [1]),
        .O(\axi_rdata[9]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCAAFFF0CCAA00)) 
    \axi_rdata[9]_i_5 
       (.I0(\write_buffer_reg[2][7]_0 [1]),
        .I1(\write_buffer_reg[3][7]_0 [1]),
        .I2(\write_buffer_reg[0][7]_0 [1]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(\write_buffer_reg[1][7]_0 [1]),
        .O(\axi_rdata[9]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    bram_rst_a_INST_0
       (.I0(s00_axi_aresetn),
        .O(SR));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    bram_we_a_INST_0_i_1
       (.I0(s00_axi_wvalid),
        .I1(s00_axi_awvalid),
        .I2(\write_buffer_reg[0][0]_1 ),
        .I3(\write_buffer_reg[0][0]_0 ),
        .O(s00_axi_wvalid_0));
  LUT5 #(
    .INIT(32'h00000080)) 
    \read_buffer[0][7]_i_1 
       (.I0(s00_axi_wdata[4]),
        .I1(p_0_in_0[0]),
        .I2(p_0_in_0[1]),
        .I3(p_0_in_0[2]),
        .I4(s00_axi_wvalid_0),
        .O(capture));
  FDRE \read_buffer_reg[0][0] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[0]),
        .Q(\read_buffer_reg[0] [0]),
        .R(SR));
  FDRE \read_buffer_reg[0][1] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[1]),
        .Q(\read_buffer_reg[0] [1]),
        .R(SR));
  FDRE \read_buffer_reg[0][2] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[2]),
        .Q(\read_buffer_reg[0] [2]),
        .R(SR));
  FDRE \read_buffer_reg[0][3] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[3]),
        .Q(\read_buffer_reg[0] [3]),
        .R(SR));
  FDRE \read_buffer_reg[0][4] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[4]),
        .Q(\read_buffer_reg[0] [4]),
        .R(SR));
  FDRE \read_buffer_reg[0][5] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[5]),
        .Q(\read_buffer_reg[0] [5]),
        .R(SR));
  FDRE \read_buffer_reg[0][6] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[6]),
        .Q(\read_buffer_reg[0] [6]),
        .R(SR));
  FDRE \read_buffer_reg[0][7] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[7]),
        .Q(\read_buffer_reg[0] [7]),
        .R(SR));
  FDRE \read_buffer_reg[1][0] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[8]),
        .Q(\read_buffer_reg[1] [0]),
        .R(SR));
  FDRE \read_buffer_reg[1][1] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[9]),
        .Q(\read_buffer_reg[1] [1]),
        .R(SR));
  FDRE \read_buffer_reg[1][2] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[10]),
        .Q(\read_buffer_reg[1] [2]),
        .R(SR));
  FDRE \read_buffer_reg[1][3] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[11]),
        .Q(\read_buffer_reg[1] [3]),
        .R(SR));
  FDRE \read_buffer_reg[1][4] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[12]),
        .Q(\read_buffer_reg[1] [4]),
        .R(SR));
  FDRE \read_buffer_reg[1][5] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[13]),
        .Q(\read_buffer_reg[1] [5]),
        .R(SR));
  FDRE \read_buffer_reg[1][6] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[14]),
        .Q(\read_buffer_reg[1] [6]),
        .R(SR));
  FDRE \read_buffer_reg[1][7] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[15]),
        .Q(\read_buffer_reg[1] [7]),
        .R(SR));
  FDRE \read_buffer_reg[2][0] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[16]),
        .Q(\read_buffer_reg[2] [0]),
        .R(SR));
  FDRE \read_buffer_reg[2][1] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[17]),
        .Q(\read_buffer_reg[2] [1]),
        .R(SR));
  FDRE \read_buffer_reg[2][2] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[18]),
        .Q(\read_buffer_reg[2] [2]),
        .R(SR));
  FDRE \read_buffer_reg[2][3] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[19]),
        .Q(\read_buffer_reg[2] [3]),
        .R(SR));
  FDRE \read_buffer_reg[2][4] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[20]),
        .Q(\read_buffer_reg[2] [4]),
        .R(SR));
  FDRE \read_buffer_reg[2][5] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[21]),
        .Q(\read_buffer_reg[2] [5]),
        .R(SR));
  FDRE \read_buffer_reg[2][6] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[22]),
        .Q(\read_buffer_reg[2] [6]),
        .R(SR));
  FDRE \read_buffer_reg[2][7] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[23]),
        .Q(\read_buffer_reg[2] [7]),
        .R(SR));
  FDRE \read_buffer_reg[3][0] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[24]),
        .Q(\read_buffer_reg[3] [0]),
        .R(SR));
  FDRE \read_buffer_reg[3][1] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[25]),
        .Q(\read_buffer_reg[3] [1]),
        .R(SR));
  FDRE \read_buffer_reg[3][2] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[26]),
        .Q(\read_buffer_reg[3] [2]),
        .R(SR));
  FDRE \read_buffer_reg[3][3] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[27]),
        .Q(\read_buffer_reg[3] [3]),
        .R(SR));
  FDRE \read_buffer_reg[3][4] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[28]),
        .Q(\read_buffer_reg[3] [4]),
        .R(SR));
  FDRE \read_buffer_reg[3][5] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[29]),
        .Q(\read_buffer_reg[3] [5]),
        .R(SR));
  FDRE \read_buffer_reg[3][6] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[30]),
        .Q(\read_buffer_reg[3] [6]),
        .R(SR));
  FDRE \read_buffer_reg[3][7] 
       (.C(s00_axi_aclk),
        .CE(capture),
        .D(perph_i[31]),
        .Q(\read_buffer_reg[3] [7]),
        .R(SR));
  LUT6 #(
    .INIT(64'h0000000000000004)) 
    \write_buffer[0][7]_i_1 
       (.I0(\write_buffer[0][7]_i_2_n_0 ),
        .I1(p_0_in_0[0]),
        .I2(p_0_in_0[2]),
        .I3(p_0_in_0[1]),
        .I4(\write_buffer[0][7]_i_3_n_0 ),
        .I5(\write_buffer_reg[0][0]_2 ),
        .O(\write_buffer[0][7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \write_buffer[0][7]_i_2 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(\write_buffer[0][7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    \write_buffer[0][7]_i_3 
       (.I0(\write_buffer_reg[0][0]_0 ),
        .I1(\write_buffer_reg[0][0]_1 ),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_wvalid),
        .I4(s00_axi_wstrb[0]),
        .O(\write_buffer[0][7]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hABAAA8AA)) 
    \write_buffer[1][0]_i_1 
       (.I0(s00_axi_wdata[0]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(s00_axi_wstrb[1]),
        .I4(s00_axi_wdata[8]),
        .O(p_0_in[0]));
  LUT5 #(
    .INIT(32'hABAAA8AA)) 
    \write_buffer[1][1]_i_1 
       (.I0(s00_axi_wdata[1]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(s00_axi_wstrb[1]),
        .I4(s00_axi_wdata[9]),
        .O(p_0_in[1]));
  LUT5 #(
    .INIT(32'hABAAA8AA)) 
    \write_buffer[1][2]_i_1 
       (.I0(s00_axi_wdata[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(s00_axi_wstrb[1]),
        .I4(s00_axi_wdata[10]),
        .O(p_0_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hABAAA8AA)) 
    \write_buffer[1][3]_i_1 
       (.I0(s00_axi_wdata[3]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(s00_axi_wstrb[1]),
        .I4(s00_axi_wdata[11]),
        .O(p_0_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hABAAA8AA)) 
    \write_buffer[1][4]_i_1 
       (.I0(s00_axi_wdata[4]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(s00_axi_wstrb[1]),
        .I4(s00_axi_wdata[12]),
        .O(p_0_in[4]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hABAAA8AA)) 
    \write_buffer[1][5]_i_1 
       (.I0(s00_axi_wdata[5]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(s00_axi_wstrb[1]),
        .I4(s00_axi_wdata[13]),
        .O(p_0_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hABAAA8AA)) 
    \write_buffer[1][6]_i_1 
       (.I0(s00_axi_wdata[6]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(s00_axi_wstrb[1]),
        .I4(s00_axi_wdata[14]),
        .O(p_0_in[6]));
  LUT6 #(
    .INIT(64'h0000010100000301)) 
    \write_buffer[1][7]_i_1 
       (.I0(\write_buffer[1][7]_i_3_n_0 ),
        .I1(\write_buffer_reg[0][0]_2 ),
        .I2(s00_axi_wvalid_0),
        .I3(s00_axi_wstrb[0]),
        .I4(\write_buffer[1][7]_i_4_n_0 ),
        .I5(\write_buffer[3][7]_i_8_n_0 ),
        .O(\write_buffer[1][7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hABAAA8AA)) 
    \write_buffer[1][7]_i_2 
       (.I0(s00_axi_wdata[7]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(s00_axi_wstrb[1]),
        .I4(s00_axi_wdata[15]),
        .O(p_0_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \write_buffer[1][7]_i_3 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(s00_axi_wstrb[1]),
        .O(\write_buffer[1][7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \write_buffer[1][7]_i_4 
       (.I0(p_0_in_0[1]),
        .I1(p_0_in_0[2]),
        .I2(p_0_in_0[0]),
        .O(\write_buffer[1][7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000F2D0F2D0)) 
    \write_buffer[2][0]_i_1 
       (.I0(s00_axi_wstrb[1]),
        .I1(\write_buffer[3][7]_i_8_n_0 ),
        .I2(s00_axi_wdata[0]),
        .I3(s00_axi_wdata[8]),
        .I4(s00_axi_wdata[16]),
        .I5(\write_buffer[2][7]_i_3_n_0 ),
        .O(\write_buffer[2][0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000F2D0F2D0)) 
    \write_buffer[2][1]_i_1 
       (.I0(s00_axi_wstrb[1]),
        .I1(\write_buffer[3][7]_i_8_n_0 ),
        .I2(s00_axi_wdata[1]),
        .I3(s00_axi_wdata[9]),
        .I4(s00_axi_wdata[17]),
        .I5(\write_buffer[2][7]_i_3_n_0 ),
        .O(\write_buffer[2][1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000FB08FB08)) 
    \write_buffer[2][2]_i_1 
       (.I0(s00_axi_wdata[10]),
        .I1(s00_axi_wstrb[1]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(s00_axi_wdata[2]),
        .I4(s00_axi_wdata[18]),
        .I5(\write_buffer[2][7]_i_3_n_0 ),
        .O(\write_buffer[2][2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000FB08FB08)) 
    \write_buffer[2][3]_i_1 
       (.I0(s00_axi_wdata[11]),
        .I1(s00_axi_wstrb[1]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(s00_axi_wdata[3]),
        .I4(s00_axi_wdata[19]),
        .I5(\write_buffer[2][7]_i_3_n_0 ),
        .O(\write_buffer[2][3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000F2D0F2D0)) 
    \write_buffer[2][4]_i_1 
       (.I0(s00_axi_wstrb[1]),
        .I1(\write_buffer[3][7]_i_8_n_0 ),
        .I2(s00_axi_wdata[4]),
        .I3(s00_axi_wdata[12]),
        .I4(s00_axi_wdata[20]),
        .I5(\write_buffer[2][7]_i_3_n_0 ),
        .O(\write_buffer[2][4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000F2D0F2D0)) 
    \write_buffer[2][5]_i_1 
       (.I0(s00_axi_wstrb[1]),
        .I1(\write_buffer[3][7]_i_8_n_0 ),
        .I2(s00_axi_wdata[5]),
        .I3(s00_axi_wdata[13]),
        .I4(s00_axi_wdata[21]),
        .I5(\write_buffer[2][7]_i_3_n_0 ),
        .O(\write_buffer[2][5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000F2D0F2D0)) 
    \write_buffer[2][6]_i_1 
       (.I0(s00_axi_wstrb[1]),
        .I1(\write_buffer[3][7]_i_8_n_0 ),
        .I2(s00_axi_wdata[6]),
        .I3(s00_axi_wdata[14]),
        .I4(s00_axi_wdata[22]),
        .I5(\write_buffer[2][7]_i_3_n_0 ),
        .O(\write_buffer[2][6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0AA800A80A080008)) 
    \write_buffer[2][7]_i_1 
       (.I0(\write_buffer[3][7]_i_3_n_0 ),
        .I1(s00_axi_wstrb[2]),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[0]),
        .O(\write_buffer[2][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000F2D0F2D0)) 
    \write_buffer[2][7]_i_2 
       (.I0(s00_axi_wstrb[1]),
        .I1(\write_buffer[3][7]_i_8_n_0 ),
        .I2(s00_axi_wdata[7]),
        .I3(s00_axi_wdata[15]),
        .I4(s00_axi_wdata[23]),
        .I5(\write_buffer[2][7]_i_3_n_0 ),
        .O(\write_buffer[2][7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \write_buffer[2][7]_i_3 
       (.I0(s00_axi_wstrb[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(\write_buffer[2][7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFB000000FB00)) 
    \write_buffer[3][0]_i_1 
       (.I0(s00_axi_wdata[16]),
        .I1(s00_axi_wstrb[2]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(\write_buffer[3][0]_i_2_n_0 ),
        .I4(\write_buffer[3][7]_i_7_n_0 ),
        .I5(s00_axi_wdata[24]),
        .O(\write_buffer[3][0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hACFAAAFAACAAAAAA)) 
    \write_buffer[3][0]_i_2 
       (.I0(s00_axi_wdata[0]),
        .I1(s00_axi_wdata[8]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[2]),
        .O(\write_buffer[3][0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFB000000FB00)) 
    \write_buffer[3][1]_i_1 
       (.I0(s00_axi_wdata[17]),
        .I1(s00_axi_wstrb[2]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(\write_buffer[3][1]_i_2_n_0 ),
        .I4(\write_buffer[3][7]_i_7_n_0 ),
        .I5(s00_axi_wdata[25]),
        .O(\write_buffer[3][1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hACFAAAFAACAAAAAA)) 
    \write_buffer[3][1]_i_2 
       (.I0(s00_axi_wdata[1]),
        .I1(s00_axi_wdata[9]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[2]),
        .O(\write_buffer[3][1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFB000000FB00)) 
    \write_buffer[3][2]_i_1 
       (.I0(s00_axi_wdata[18]),
        .I1(s00_axi_wstrb[2]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(\write_buffer[3][2]_i_2_n_0 ),
        .I4(\write_buffer[3][7]_i_7_n_0 ),
        .I5(s00_axi_wdata[26]),
        .O(\write_buffer[3][2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hACFAAAFAACAAAAAA)) 
    \write_buffer[3][2]_i_2 
       (.I0(s00_axi_wdata[2]),
        .I1(s00_axi_wdata[10]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[2]),
        .O(\write_buffer[3][2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFB000000FB00)) 
    \write_buffer[3][3]_i_1 
       (.I0(s00_axi_wdata[19]),
        .I1(s00_axi_wstrb[2]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(\write_buffer[3][3]_i_2_n_0 ),
        .I4(\write_buffer[3][7]_i_7_n_0 ),
        .I5(s00_axi_wdata[27]),
        .O(\write_buffer[3][3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hCAFCCCFCCACCCCCC)) 
    \write_buffer[3][3]_i_2 
       (.I0(s00_axi_wdata[11]),
        .I1(s00_axi_wdata[3]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[2]),
        .O(\write_buffer[3][3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFB000000FB00)) 
    \write_buffer[3][4]_i_1 
       (.I0(s00_axi_wdata[20]),
        .I1(s00_axi_wstrb[2]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(\write_buffer[3][4]_i_2_n_0 ),
        .I4(\write_buffer[3][7]_i_7_n_0 ),
        .I5(s00_axi_wdata[28]),
        .O(\write_buffer[3][4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hACFAAAFAACAAAAAA)) 
    \write_buffer[3][4]_i_2 
       (.I0(s00_axi_wdata[4]),
        .I1(s00_axi_wdata[12]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[2]),
        .O(\write_buffer[3][4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFB000000FB00)) 
    \write_buffer[3][5]_i_1 
       (.I0(s00_axi_wdata[21]),
        .I1(s00_axi_wstrb[2]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(\write_buffer[3][5]_i_2_n_0 ),
        .I4(\write_buffer[3][7]_i_7_n_0 ),
        .I5(s00_axi_wdata[29]),
        .O(\write_buffer[3][5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hACFAAAFAACAAAAAA)) 
    \write_buffer[3][5]_i_2 
       (.I0(s00_axi_wdata[5]),
        .I1(s00_axi_wdata[13]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[2]),
        .O(\write_buffer[3][5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFB000000FB00)) 
    \write_buffer[3][6]_i_1 
       (.I0(s00_axi_wdata[22]),
        .I1(s00_axi_wstrb[2]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(\write_buffer[3][6]_i_2_n_0 ),
        .I4(\write_buffer[3][7]_i_7_n_0 ),
        .I5(s00_axi_wdata[30]),
        .O(\write_buffer[3][6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hACFAAAFAACAAAAAA)) 
    \write_buffer[3][6]_i_2 
       (.I0(s00_axi_wdata[6]),
        .I1(s00_axi_wdata[14]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[2]),
        .O(\write_buffer[3][6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAAA8A8AAA8)) 
    \write_buffer[3][7]_i_1 
       (.I0(\write_buffer[3][7]_i_3_n_0 ),
        .I1(\write_buffer[3][7]_i_4_n_0 ),
        .I2(\write_buffer[3][7]_i_5_n_0 ),
        .I3(s00_axi_wstrb[0]),
        .I4(\write_buffer[3][7]_i_6_n_0 ),
        .I5(\write_buffer[3][7]_i_7_n_0 ),
        .O(write_buffer));
  LUT6 #(
    .INIT(64'hFFFFFB000000FB00)) 
    \write_buffer[3][7]_i_2 
       (.I0(s00_axi_wdata[23]),
        .I1(s00_axi_wstrb[2]),
        .I2(\write_buffer[3][7]_i_8_n_0 ),
        .I3(\write_buffer[3][7]_i_9_n_0 ),
        .I4(\write_buffer[3][7]_i_7_n_0 ),
        .I5(s00_axi_wdata[31]),
        .O(\write_buffer[3][7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00000100)) 
    \write_buffer[3][7]_i_3 
       (.I0(s00_axi_wvalid_0),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[2]),
        .I3(p_0_in_0[0]),
        .I4(\write_buffer_reg[0][0]_2 ),
        .O(\write_buffer[3][7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \write_buffer[3][7]_i_4 
       (.I0(s00_axi_wstrb[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(\write_buffer[3][7]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \write_buffer[3][7]_i_5 
       (.I0(s00_axi_wstrb[1]),
        .I1(Q[1]),
        .I2(Q[0]),
        .O(\write_buffer[3][7]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \write_buffer[3][7]_i_6 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(\write_buffer[3][7]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'h02)) 
    \write_buffer[3][7]_i_7 
       (.I0(s00_axi_wstrb[3]),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(\write_buffer[3][7]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \write_buffer[3][7]_i_8 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(\write_buffer[3][7]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hACFAAAFAACAAAAAA)) 
    \write_buffer[3][7]_i_9 
       (.I0(s00_axi_wdata[7]),
        .I1(s00_axi_wdata[15]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(s00_axi_wstrb[2]),
        .O(\write_buffer[3][7]_i_9_n_0 ));
  FDRE \write_buffer_reg[0][0] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[0][7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(\write_buffer_reg[0][7]_0 [0]),
        .R(SR));
  FDRE \write_buffer_reg[0][1] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[0][7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(\write_buffer_reg[0][7]_0 [1]),
        .R(SR));
  FDRE \write_buffer_reg[0][2] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[0][7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(\write_buffer_reg[0][7]_0 [2]),
        .R(SR));
  FDRE \write_buffer_reg[0][3] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[0][7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(\write_buffer_reg[0][7]_0 [3]),
        .R(SR));
  FDRE \write_buffer_reg[0][4] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[0][7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(\write_buffer_reg[0][7]_0 [4]),
        .R(SR));
  FDRE \write_buffer_reg[0][5] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[0][7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(\write_buffer_reg[0][7]_0 [5]),
        .R(SR));
  FDRE \write_buffer_reg[0][6] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[0][7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(\write_buffer_reg[0][7]_0 [6]),
        .R(SR));
  FDRE \write_buffer_reg[0][7] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[0][7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(\write_buffer_reg[0][7]_0 [7]),
        .R(SR));
  FDRE \write_buffer_reg[1][0] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[1][7]_i_1_n_0 ),
        .D(p_0_in[0]),
        .Q(\write_buffer_reg[1][7]_0 [0]),
        .R(SR));
  FDRE \write_buffer_reg[1][1] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[1][7]_i_1_n_0 ),
        .D(p_0_in[1]),
        .Q(\write_buffer_reg[1][7]_0 [1]),
        .R(SR));
  FDRE \write_buffer_reg[1][2] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[1][7]_i_1_n_0 ),
        .D(p_0_in[2]),
        .Q(\write_buffer_reg[1][7]_0 [2]),
        .R(SR));
  FDRE \write_buffer_reg[1][3] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[1][7]_i_1_n_0 ),
        .D(p_0_in[3]),
        .Q(\write_buffer_reg[1][7]_0 [3]),
        .R(SR));
  FDRE \write_buffer_reg[1][4] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[1][7]_i_1_n_0 ),
        .D(p_0_in[4]),
        .Q(\write_buffer_reg[1][7]_0 [4]),
        .R(SR));
  FDRE \write_buffer_reg[1][5] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[1][7]_i_1_n_0 ),
        .D(p_0_in[5]),
        .Q(\write_buffer_reg[1][7]_0 [5]),
        .R(SR));
  FDRE \write_buffer_reg[1][6] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[1][7]_i_1_n_0 ),
        .D(p_0_in[6]),
        .Q(\write_buffer_reg[1][7]_0 [6]),
        .R(SR));
  FDRE \write_buffer_reg[1][7] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[1][7]_i_1_n_0 ),
        .D(p_0_in[7]),
        .Q(\write_buffer_reg[1][7]_0 [7]),
        .R(SR));
  FDRE \write_buffer_reg[2][0] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[2][7]_i_1_n_0 ),
        .D(\write_buffer[2][0]_i_1_n_0 ),
        .Q(\write_buffer_reg[2][7]_0 [0]),
        .R(SR));
  FDRE \write_buffer_reg[2][1] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[2][7]_i_1_n_0 ),
        .D(\write_buffer[2][1]_i_1_n_0 ),
        .Q(\write_buffer_reg[2][7]_0 [1]),
        .R(SR));
  FDRE \write_buffer_reg[2][2] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[2][7]_i_1_n_0 ),
        .D(\write_buffer[2][2]_i_1_n_0 ),
        .Q(\write_buffer_reg[2][7]_0 [2]),
        .R(SR));
  FDRE \write_buffer_reg[2][3] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[2][7]_i_1_n_0 ),
        .D(\write_buffer[2][3]_i_1_n_0 ),
        .Q(\write_buffer_reg[2][7]_0 [3]),
        .R(SR));
  FDRE \write_buffer_reg[2][4] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[2][7]_i_1_n_0 ),
        .D(\write_buffer[2][4]_i_1_n_0 ),
        .Q(\write_buffer_reg[2][7]_0 [4]),
        .R(SR));
  FDRE \write_buffer_reg[2][5] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[2][7]_i_1_n_0 ),
        .D(\write_buffer[2][5]_i_1_n_0 ),
        .Q(\write_buffer_reg[2][7]_0 [5]),
        .R(SR));
  FDRE \write_buffer_reg[2][6] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[2][7]_i_1_n_0 ),
        .D(\write_buffer[2][6]_i_1_n_0 ),
        .Q(\write_buffer_reg[2][7]_0 [6]),
        .R(SR));
  FDRE \write_buffer_reg[2][7] 
       (.C(s00_axi_aclk),
        .CE(\write_buffer[2][7]_i_1_n_0 ),
        .D(\write_buffer[2][7]_i_2_n_0 ),
        .Q(\write_buffer_reg[2][7]_0 [7]),
        .R(SR));
  FDRE \write_buffer_reg[3][0] 
       (.C(s00_axi_aclk),
        .CE(write_buffer),
        .D(\write_buffer[3][0]_i_1_n_0 ),
        .Q(\write_buffer_reg[3][7]_0 [0]),
        .R(SR));
  FDRE \write_buffer_reg[3][1] 
       (.C(s00_axi_aclk),
        .CE(write_buffer),
        .D(\write_buffer[3][1]_i_1_n_0 ),
        .Q(\write_buffer_reg[3][7]_0 [1]),
        .R(SR));
  FDRE \write_buffer_reg[3][2] 
       (.C(s00_axi_aclk),
        .CE(write_buffer),
        .D(\write_buffer[3][2]_i_1_n_0 ),
        .Q(\write_buffer_reg[3][7]_0 [2]),
        .R(SR));
  FDRE \write_buffer_reg[3][3] 
       (.C(s00_axi_aclk),
        .CE(write_buffer),
        .D(\write_buffer[3][3]_i_1_n_0 ),
        .Q(\write_buffer_reg[3][7]_0 [3]),
        .R(SR));
  FDRE \write_buffer_reg[3][4] 
       (.C(s00_axi_aclk),
        .CE(write_buffer),
        .D(\write_buffer[3][4]_i_1_n_0 ),
        .Q(\write_buffer_reg[3][7]_0 [4]),
        .R(SR));
  FDRE \write_buffer_reg[3][5] 
       (.C(s00_axi_aclk),
        .CE(write_buffer),
        .D(\write_buffer[3][5]_i_1_n_0 ),
        .Q(\write_buffer_reg[3][7]_0 [5]),
        .R(SR));
  FDRE \write_buffer_reg[3][6] 
       (.C(s00_axi_aclk),
        .CE(write_buffer),
        .D(\write_buffer[3][6]_i_1_n_0 ),
        .Q(\write_buffer_reg[3][7]_0 [6]),
        .R(SR));
  FDRE \write_buffer_reg[3][7] 
       (.C(s00_axi_aclk),
        .CE(write_buffer),
        .D(\write_buffer[3][7]_i_2_n_0 ),
        .Q(\write_buffer_reg[3][7]_0 [7]),
        .R(SR));
endmodule

(* CHECK_LICENSE_TYPE = "validation_example_Module_Validation_Pl_0_0,Module_Validation_Platform_v1_0,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "Module_Validation_Platform_v1_0,Vivado 2024.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clk_o,
    perph_o,
    perph_i,
    bram_addr_a,
    bram_clk_a,
    bram_wrdata_a,
    bram_rddata_a,
    bram_en_a,
    bram_rst_a,
    bram_we_a,
    s00_axi_aclk,
    s00_axi_aresetn,
    s00_axi_awaddr,
    s00_axi_awprot,
    s00_axi_awvalid,
    s00_axi_awready,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_wvalid,
    s00_axi_wready,
    s00_axi_bresp,
    s00_axi_bvalid,
    s00_axi_bready,
    s00_axi_araddr,
    s00_axi_arprot,
    s00_axi_arvalid,
    s00_axi_arready,
    s00_axi_rdata,
    s00_axi_rresp,
    s00_axi_rvalid,
    s00_axi_rready);
  output clk_o;
  output [31:0]perph_o;
  input [31:0]perph_i;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) output [11:0]bram_addr_a;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) output bram_clk_a;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) output [31:0]bram_wrdata_a;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) input [31:0]bram_rddata_a;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) output bram_en_a;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) output bram_rst_a;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) output bram_we_a;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN validation_example_processing_system7_0_1_FCLK_CLK0, INSERT_VIP 0" *) input s00_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_AXI_RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s00_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR" *) input [4:0]s00_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT" *) input [2:0]s00_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID" *) input s00_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY" *) output s00_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WDATA" *) input [31:0]s00_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB" *) input [3:0]s00_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WVALID" *) input s00_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WREADY" *) output s00_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BRESP" *) output [1:0]s00_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BVALID" *) output s00_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BREADY" *) input s00_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR" *) input [4:0]s00_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT" *) input [2:0]s00_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID" *) input s00_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY" *) output s00_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RDATA" *) output [31:0]s00_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RRESP" *) output [1:0]s00_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RVALID" *) output s00_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RREADY" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 8, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 5, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN validation_example_processing_system7_0_1_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input s00_axi_rready;

  wire \<const0> ;
  wire [11:0]bram_addr_a;
  wire bram_en_a;
  wire [31:0]bram_rddata_a;
  wire bram_rst_a;
  wire bram_we_a;
  wire clk_o;
  wire [31:0]perph_i;
  wire [31:0]perph_o;
  wire s00_axi_aclk;
  wire [4:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arready;
  wire s00_axi_arvalid;
  wire [4:0]s00_axi_awaddr;
  wire s00_axi_awready;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wready;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;

  assign bram_clk_a = clk_o;
  assign bram_wrdata_a[31:0] = s00_axi_wdata;
  assign s00_axi_bresp[1] = \<const0> ;
  assign s00_axi_bresp[0] = \<const0> ;
  assign s00_axi_rresp[1] = \<const0> ;
  assign s00_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_Module_Validation_Platform_v1_0 inst
       (.Q(bram_addr_a),
        .SR(bram_rst_a),
        .S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WREADY(s00_axi_wready),
        .bram_en_a(bram_en_a),
        .bram_rddata_a(bram_rddata_a),
        .bram_we_a(bram_we_a),
        .clk_o(clk_o),
        .perph_i(perph_i),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_araddr(s00_axi_araddr[4:2]),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr[4:2]),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid),
        .\write_buffer_reg[0][7] (perph_o[7:0]),
        .\write_buffer_reg[1][7] (perph_o[15:8]),
        .\write_buffer_reg[2][7] (perph_o[23:16]),
        .\write_buffer_reg[3][7] (perph_o[31:24]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
