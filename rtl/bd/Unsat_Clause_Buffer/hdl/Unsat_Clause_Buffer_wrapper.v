//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
//Date        : Fri Jul 19 18:03:48 2024
//Host        : Barry-Home-PC running 64-bit major release  (build 9200)
//Command     : generate_target Unsat_Clause_Buffer_wrapper.bd
//Design      : Unsat_Clause_Buffer_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Unsat_Clause_Buffer_wrapper
   (ACLK_0,
    ARESETN_0,
    S00_AXI_0_araddr,
    S00_AXI_0_arburst,
    S00_AXI_0_arcache,
    S00_AXI_0_arlen,
    S00_AXI_0_arlock,
    S00_AXI_0_arprot,
    S00_AXI_0_arqos,
    S00_AXI_0_arready,
    S00_AXI_0_arsize,
    S00_AXI_0_arvalid,
    S00_AXI_0_awaddr,
    S00_AXI_0_awburst,
    S00_AXI_0_awcache,
    S00_AXI_0_awlen,
    S00_AXI_0_awlock,
    S00_AXI_0_awprot,
    S00_AXI_0_awqos,
    S00_AXI_0_awready,
    S00_AXI_0_awsize,
    S00_AXI_0_awvalid,
    S00_AXI_0_bready,
    S00_AXI_0_bresp,
    S00_AXI_0_bvalid,
    S00_AXI_0_rdata,
    S00_AXI_0_rlast,
    S00_AXI_0_rready,
    S00_AXI_0_rresp,
    S00_AXI_0_rvalid,
    S00_AXI_0_wdata,
    S00_AXI_0_wlast,
    S00_AXI_0_wready,
    S00_AXI_0_wstrb,
    S00_AXI_0_wvalid,
    clause_addr_i,
    clause_i,
    clause_o,
    clause_wren_i,
    en_i,
    reset_i,
    rst_busy_o);
  input ACLK_0;
  input ARESETN_0;
  input [31:0]S00_AXI_0_araddr;
  input [1:0]S00_AXI_0_arburst;
  input [3:0]S00_AXI_0_arcache;
  input [7:0]S00_AXI_0_arlen;
  input [0:0]S00_AXI_0_arlock;
  input [2:0]S00_AXI_0_arprot;
  input [3:0]S00_AXI_0_arqos;
  output [0:0]S00_AXI_0_arready;
  input [2:0]S00_AXI_0_arsize;
  input [0:0]S00_AXI_0_arvalid;
  input [31:0]S00_AXI_0_awaddr;
  input [1:0]S00_AXI_0_awburst;
  input [3:0]S00_AXI_0_awcache;
  input [7:0]S00_AXI_0_awlen;
  input [0:0]S00_AXI_0_awlock;
  input [2:0]S00_AXI_0_awprot;
  input [3:0]S00_AXI_0_awqos;
  output [0:0]S00_AXI_0_awready;
  input [2:0]S00_AXI_0_awsize;
  input [0:0]S00_AXI_0_awvalid;
  input [0:0]S00_AXI_0_bready;
  output [1:0]S00_AXI_0_bresp;
  output [0:0]S00_AXI_0_bvalid;
  output [31:0]S00_AXI_0_rdata;
  output [0:0]S00_AXI_0_rlast;
  input [0:0]S00_AXI_0_rready;
  output [1:0]S00_AXI_0_rresp;
  output [0:0]S00_AXI_0_rvalid;
  input [31:0]S00_AXI_0_wdata;
  input [0:0]S00_AXI_0_wlast;
  output [0:0]S00_AXI_0_wready;
  input [3:0]S00_AXI_0_wstrb;
  input [0:0]S00_AXI_0_wvalid;
  input [12:0]clause_addr_i;
  input [35:0]clause_i;
  output [35:0]clause_o;
  input clause_wren_i;
  input en_i;
  input reset_i;
  output rst_busy_o;

  wire ACLK_0;
  wire ARESETN_0;
  wire [31:0]S00_AXI_0_araddr;
  wire [1:0]S00_AXI_0_arburst;
  wire [3:0]S00_AXI_0_arcache;
  wire [7:0]S00_AXI_0_arlen;
  wire [0:0]S00_AXI_0_arlock;
  wire [2:0]S00_AXI_0_arprot;
  wire [3:0]S00_AXI_0_arqos;
  wire [0:0]S00_AXI_0_arready;
  wire [2:0]S00_AXI_0_arsize;
  wire [0:0]S00_AXI_0_arvalid;
  wire [31:0]S00_AXI_0_awaddr;
  wire [1:0]S00_AXI_0_awburst;
  wire [3:0]S00_AXI_0_awcache;
  wire [7:0]S00_AXI_0_awlen;
  wire [0:0]S00_AXI_0_awlock;
  wire [2:0]S00_AXI_0_awprot;
  wire [3:0]S00_AXI_0_awqos;
  wire [0:0]S00_AXI_0_awready;
  wire [2:0]S00_AXI_0_awsize;
  wire [0:0]S00_AXI_0_awvalid;
  wire [0:0]S00_AXI_0_bready;
  wire [1:0]S00_AXI_0_bresp;
  wire [0:0]S00_AXI_0_bvalid;
  wire [31:0]S00_AXI_0_rdata;
  wire [0:0]S00_AXI_0_rlast;
  wire [0:0]S00_AXI_0_rready;
  wire [1:0]S00_AXI_0_rresp;
  wire [0:0]S00_AXI_0_rvalid;
  wire [31:0]S00_AXI_0_wdata;
  wire [0:0]S00_AXI_0_wlast;
  wire [0:0]S00_AXI_0_wready;
  wire [3:0]S00_AXI_0_wstrb;
  wire [0:0]S00_AXI_0_wvalid;
  wire [12:0]clause_addr_i;
  wire [35:0]clause_i;
  wire [35:0]clause_o;
  wire clause_wren_i;
  wire en_i;
  wire reset_i;
  wire rst_busy_o;

  Unsat_Clause_Buffer Unsat_Clause_Buffer_i
       (.ACLK_0(ACLK_0),
        .ARESETN_0(ARESETN_0),
        .S00_AXI_0_araddr(S00_AXI_0_araddr),
        .S00_AXI_0_arburst(S00_AXI_0_arburst),
        .S00_AXI_0_arcache(S00_AXI_0_arcache),
        .S00_AXI_0_arlen(S00_AXI_0_arlen),
        .S00_AXI_0_arlock(S00_AXI_0_arlock),
        .S00_AXI_0_arprot(S00_AXI_0_arprot),
        .S00_AXI_0_arqos(S00_AXI_0_arqos),
        .S00_AXI_0_arready(S00_AXI_0_arready),
        .S00_AXI_0_arsize(S00_AXI_0_arsize),
        .S00_AXI_0_arvalid(S00_AXI_0_arvalid),
        .S00_AXI_0_awaddr(S00_AXI_0_awaddr),
        .S00_AXI_0_awburst(S00_AXI_0_awburst),
        .S00_AXI_0_awcache(S00_AXI_0_awcache),
        .S00_AXI_0_awlen(S00_AXI_0_awlen),
        .S00_AXI_0_awlock(S00_AXI_0_awlock),
        .S00_AXI_0_awprot(S00_AXI_0_awprot),
        .S00_AXI_0_awqos(S00_AXI_0_awqos),
        .S00_AXI_0_awready(S00_AXI_0_awready),
        .S00_AXI_0_awsize(S00_AXI_0_awsize),
        .S00_AXI_0_awvalid(S00_AXI_0_awvalid),
        .S00_AXI_0_bready(S00_AXI_0_bready),
        .S00_AXI_0_bresp(S00_AXI_0_bresp),
        .S00_AXI_0_bvalid(S00_AXI_0_bvalid),
        .S00_AXI_0_rdata(S00_AXI_0_rdata),
        .S00_AXI_0_rlast(S00_AXI_0_rlast),
        .S00_AXI_0_rready(S00_AXI_0_rready),
        .S00_AXI_0_rresp(S00_AXI_0_rresp),
        .S00_AXI_0_rvalid(S00_AXI_0_rvalid),
        .S00_AXI_0_wdata(S00_AXI_0_wdata),
        .S00_AXI_0_wlast(S00_AXI_0_wlast),
        .S00_AXI_0_wready(S00_AXI_0_wready),
        .S00_AXI_0_wstrb(S00_AXI_0_wstrb),
        .S00_AXI_0_wvalid(S00_AXI_0_wvalid),
        .clause_addr_i(clause_addr_i),
        .clause_i(clause_i),
        .clause_o(clause_o),
        .clause_wren_i(clause_wren_i),
        .en_i(en_i),
        .reset_i(reset_i),
        .rst_busy_o(rst_busy_o));
endmodule
