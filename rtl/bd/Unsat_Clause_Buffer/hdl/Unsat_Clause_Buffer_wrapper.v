//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
//Date        : Fri Jul 19 18:54:27 2024
//Host        : Barry-Home-PC running 64-bit major release  (build 9200)
//Command     : generate_target Unsat_Clause_Buffer_wrapper.bd
//Design      : Unsat_Clause_Buffer_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Unsat_Clause_Buffer_wrapper
   (ACLK_0,
    ARESETN_0,
    S_AXI_HIGH_araddr,
    S_AXI_HIGH_arburst,
    S_AXI_HIGH_arcache,
    S_AXI_HIGH_arlen,
    S_AXI_HIGH_arlock,
    S_AXI_HIGH_arprot,
    S_AXI_HIGH_arready,
    S_AXI_HIGH_arsize,
    S_AXI_HIGH_arvalid,
    S_AXI_HIGH_awaddr,
    S_AXI_HIGH_awburst,
    S_AXI_HIGH_awcache,
    S_AXI_HIGH_awlen,
    S_AXI_HIGH_awlock,
    S_AXI_HIGH_awprot,
    S_AXI_HIGH_awready,
    S_AXI_HIGH_awsize,
    S_AXI_HIGH_awvalid,
    S_AXI_HIGH_bready,
    S_AXI_HIGH_bresp,
    S_AXI_HIGH_bvalid,
    S_AXI_HIGH_rdata,
    S_AXI_HIGH_rlast,
    S_AXI_HIGH_rready,
    S_AXI_HIGH_rresp,
    S_AXI_HIGH_rvalid,
    S_AXI_HIGH_wdata,
    S_AXI_HIGH_wlast,
    S_AXI_HIGH_wready,
    S_AXI_HIGH_wstrb,
    S_AXI_HIGH_wvalid,
    S_AXI_LOW_araddr,
    S_AXI_LOW_arburst,
    S_AXI_LOW_arcache,
    S_AXI_LOW_arlen,
    S_AXI_LOW_arlock,
    S_AXI_LOW_arprot,
    S_AXI_LOW_arready,
    S_AXI_LOW_arsize,
    S_AXI_LOW_arvalid,
    S_AXI_LOW_awaddr,
    S_AXI_LOW_awburst,
    S_AXI_LOW_awcache,
    S_AXI_LOW_awlen,
    S_AXI_LOW_awlock,
    S_AXI_LOW_awprot,
    S_AXI_LOW_awready,
    S_AXI_LOW_awsize,
    S_AXI_LOW_awvalid,
    S_AXI_LOW_bready,
    S_AXI_LOW_bresp,
    S_AXI_LOW_bvalid,
    S_AXI_LOW_rdata,
    S_AXI_LOW_rlast,
    S_AXI_LOW_rready,
    S_AXI_LOW_rresp,
    S_AXI_LOW_rvalid,
    S_AXI_LOW_wdata,
    S_AXI_LOW_wlast,
    S_AXI_LOW_wready,
    S_AXI_LOW_wstrb,
    S_AXI_LOW_wvalid,
    clause_addr_i,
    clause_i,
    clause_o,
    clause_wren_i,
    en_i,
    reset_i,
    rst_busy_o);
  input ACLK_0;
  input ARESETN_0;
  input [11:0]S_AXI_HIGH_araddr;
  input [1:0]S_AXI_HIGH_arburst;
  input [3:0]S_AXI_HIGH_arcache;
  input [7:0]S_AXI_HIGH_arlen;
  input S_AXI_HIGH_arlock;
  input [2:0]S_AXI_HIGH_arprot;
  output S_AXI_HIGH_arready;
  input [2:0]S_AXI_HIGH_arsize;
  input S_AXI_HIGH_arvalid;
  input [11:0]S_AXI_HIGH_awaddr;
  input [1:0]S_AXI_HIGH_awburst;
  input [3:0]S_AXI_HIGH_awcache;
  input [7:0]S_AXI_HIGH_awlen;
  input S_AXI_HIGH_awlock;
  input [2:0]S_AXI_HIGH_awprot;
  output S_AXI_HIGH_awready;
  input [2:0]S_AXI_HIGH_awsize;
  input S_AXI_HIGH_awvalid;
  input S_AXI_HIGH_bready;
  output [1:0]S_AXI_HIGH_bresp;
  output S_AXI_HIGH_bvalid;
  output [31:0]S_AXI_HIGH_rdata;
  output S_AXI_HIGH_rlast;
  input S_AXI_HIGH_rready;
  output [1:0]S_AXI_HIGH_rresp;
  output S_AXI_HIGH_rvalid;
  input [31:0]S_AXI_HIGH_wdata;
  input S_AXI_HIGH_wlast;
  output S_AXI_HIGH_wready;
  input [3:0]S_AXI_HIGH_wstrb;
  input S_AXI_HIGH_wvalid;
  input [14:0]S_AXI_LOW_araddr;
  input [1:0]S_AXI_LOW_arburst;
  input [3:0]S_AXI_LOW_arcache;
  input [7:0]S_AXI_LOW_arlen;
  input S_AXI_LOW_arlock;
  input [2:0]S_AXI_LOW_arprot;
  output S_AXI_LOW_arready;
  input [2:0]S_AXI_LOW_arsize;
  input S_AXI_LOW_arvalid;
  input [14:0]S_AXI_LOW_awaddr;
  input [1:0]S_AXI_LOW_awburst;
  input [3:0]S_AXI_LOW_awcache;
  input [7:0]S_AXI_LOW_awlen;
  input S_AXI_LOW_awlock;
  input [2:0]S_AXI_LOW_awprot;
  output S_AXI_LOW_awready;
  input [2:0]S_AXI_LOW_awsize;
  input S_AXI_LOW_awvalid;
  input S_AXI_LOW_bready;
  output [1:0]S_AXI_LOW_bresp;
  output S_AXI_LOW_bvalid;
  output [31:0]S_AXI_LOW_rdata;
  output S_AXI_LOW_rlast;
  input S_AXI_LOW_rready;
  output [1:0]S_AXI_LOW_rresp;
  output S_AXI_LOW_rvalid;
  input [31:0]S_AXI_LOW_wdata;
  input S_AXI_LOW_wlast;
  output S_AXI_LOW_wready;
  input [3:0]S_AXI_LOW_wstrb;
  input S_AXI_LOW_wvalid;
  input [12:0]clause_addr_i;
  input [35:0]clause_i;
  output [35:0]clause_o;
  input clause_wren_i;
  input en_i;
  input reset_i;
  output rst_busy_o;

  wire ACLK_0;
  wire ARESETN_0;
  wire [11:0]S_AXI_HIGH_araddr;
  wire [1:0]S_AXI_HIGH_arburst;
  wire [3:0]S_AXI_HIGH_arcache;
  wire [7:0]S_AXI_HIGH_arlen;
  wire S_AXI_HIGH_arlock;
  wire [2:0]S_AXI_HIGH_arprot;
  wire S_AXI_HIGH_arready;
  wire [2:0]S_AXI_HIGH_arsize;
  wire S_AXI_HIGH_arvalid;
  wire [11:0]S_AXI_HIGH_awaddr;
  wire [1:0]S_AXI_HIGH_awburst;
  wire [3:0]S_AXI_HIGH_awcache;
  wire [7:0]S_AXI_HIGH_awlen;
  wire S_AXI_HIGH_awlock;
  wire [2:0]S_AXI_HIGH_awprot;
  wire S_AXI_HIGH_awready;
  wire [2:0]S_AXI_HIGH_awsize;
  wire S_AXI_HIGH_awvalid;
  wire S_AXI_HIGH_bready;
  wire [1:0]S_AXI_HIGH_bresp;
  wire S_AXI_HIGH_bvalid;
  wire [31:0]S_AXI_HIGH_rdata;
  wire S_AXI_HIGH_rlast;
  wire S_AXI_HIGH_rready;
  wire [1:0]S_AXI_HIGH_rresp;
  wire S_AXI_HIGH_rvalid;
  wire [31:0]S_AXI_HIGH_wdata;
  wire S_AXI_HIGH_wlast;
  wire S_AXI_HIGH_wready;
  wire [3:0]S_AXI_HIGH_wstrb;
  wire S_AXI_HIGH_wvalid;
  wire [14:0]S_AXI_LOW_araddr;
  wire [1:0]S_AXI_LOW_arburst;
  wire [3:0]S_AXI_LOW_arcache;
  wire [7:0]S_AXI_LOW_arlen;
  wire S_AXI_LOW_arlock;
  wire [2:0]S_AXI_LOW_arprot;
  wire S_AXI_LOW_arready;
  wire [2:0]S_AXI_LOW_arsize;
  wire S_AXI_LOW_arvalid;
  wire [14:0]S_AXI_LOW_awaddr;
  wire [1:0]S_AXI_LOW_awburst;
  wire [3:0]S_AXI_LOW_awcache;
  wire [7:0]S_AXI_LOW_awlen;
  wire S_AXI_LOW_awlock;
  wire [2:0]S_AXI_LOW_awprot;
  wire S_AXI_LOW_awready;
  wire [2:0]S_AXI_LOW_awsize;
  wire S_AXI_LOW_awvalid;
  wire S_AXI_LOW_bready;
  wire [1:0]S_AXI_LOW_bresp;
  wire S_AXI_LOW_bvalid;
  wire [31:0]S_AXI_LOW_rdata;
  wire S_AXI_LOW_rlast;
  wire S_AXI_LOW_rready;
  wire [1:0]S_AXI_LOW_rresp;
  wire S_AXI_LOW_rvalid;
  wire [31:0]S_AXI_LOW_wdata;
  wire S_AXI_LOW_wlast;
  wire S_AXI_LOW_wready;
  wire [3:0]S_AXI_LOW_wstrb;
  wire S_AXI_LOW_wvalid;
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
        .S_AXI_HIGH_araddr(S_AXI_HIGH_araddr),
        .S_AXI_HIGH_arburst(S_AXI_HIGH_arburst),
        .S_AXI_HIGH_arcache(S_AXI_HIGH_arcache),
        .S_AXI_HIGH_arlen(S_AXI_HIGH_arlen),
        .S_AXI_HIGH_arlock(S_AXI_HIGH_arlock),
        .S_AXI_HIGH_arprot(S_AXI_HIGH_arprot),
        .S_AXI_HIGH_arready(S_AXI_HIGH_arready),
        .S_AXI_HIGH_arsize(S_AXI_HIGH_arsize),
        .S_AXI_HIGH_arvalid(S_AXI_HIGH_arvalid),
        .S_AXI_HIGH_awaddr(S_AXI_HIGH_awaddr),
        .S_AXI_HIGH_awburst(S_AXI_HIGH_awburst),
        .S_AXI_HIGH_awcache(S_AXI_HIGH_awcache),
        .S_AXI_HIGH_awlen(S_AXI_HIGH_awlen),
        .S_AXI_HIGH_awlock(S_AXI_HIGH_awlock),
        .S_AXI_HIGH_awprot(S_AXI_HIGH_awprot),
        .S_AXI_HIGH_awready(S_AXI_HIGH_awready),
        .S_AXI_HIGH_awsize(S_AXI_HIGH_awsize),
        .S_AXI_HIGH_awvalid(S_AXI_HIGH_awvalid),
        .S_AXI_HIGH_bready(S_AXI_HIGH_bready),
        .S_AXI_HIGH_bresp(S_AXI_HIGH_bresp),
        .S_AXI_HIGH_bvalid(S_AXI_HIGH_bvalid),
        .S_AXI_HIGH_rdata(S_AXI_HIGH_rdata),
        .S_AXI_HIGH_rlast(S_AXI_HIGH_rlast),
        .S_AXI_HIGH_rready(S_AXI_HIGH_rready),
        .S_AXI_HIGH_rresp(S_AXI_HIGH_rresp),
        .S_AXI_HIGH_rvalid(S_AXI_HIGH_rvalid),
        .S_AXI_HIGH_wdata(S_AXI_HIGH_wdata),
        .S_AXI_HIGH_wlast(S_AXI_HIGH_wlast),
        .S_AXI_HIGH_wready(S_AXI_HIGH_wready),
        .S_AXI_HIGH_wstrb(S_AXI_HIGH_wstrb),
        .S_AXI_HIGH_wvalid(S_AXI_HIGH_wvalid),
        .S_AXI_LOW_araddr(S_AXI_LOW_araddr),
        .S_AXI_LOW_arburst(S_AXI_LOW_arburst),
        .S_AXI_LOW_arcache(S_AXI_LOW_arcache),
        .S_AXI_LOW_arlen(S_AXI_LOW_arlen),
        .S_AXI_LOW_arlock(S_AXI_LOW_arlock),
        .S_AXI_LOW_arprot(S_AXI_LOW_arprot),
        .S_AXI_LOW_arready(S_AXI_LOW_arready),
        .S_AXI_LOW_arsize(S_AXI_LOW_arsize),
        .S_AXI_LOW_arvalid(S_AXI_LOW_arvalid),
        .S_AXI_LOW_awaddr(S_AXI_LOW_awaddr),
        .S_AXI_LOW_awburst(S_AXI_LOW_awburst),
        .S_AXI_LOW_awcache(S_AXI_LOW_awcache),
        .S_AXI_LOW_awlen(S_AXI_LOW_awlen),
        .S_AXI_LOW_awlock(S_AXI_LOW_awlock),
        .S_AXI_LOW_awprot(S_AXI_LOW_awprot),
        .S_AXI_LOW_awready(S_AXI_LOW_awready),
        .S_AXI_LOW_awsize(S_AXI_LOW_awsize),
        .S_AXI_LOW_awvalid(S_AXI_LOW_awvalid),
        .S_AXI_LOW_bready(S_AXI_LOW_bready),
        .S_AXI_LOW_bresp(S_AXI_LOW_bresp),
        .S_AXI_LOW_bvalid(S_AXI_LOW_bvalid),
        .S_AXI_LOW_rdata(S_AXI_LOW_rdata),
        .S_AXI_LOW_rlast(S_AXI_LOW_rlast),
        .S_AXI_LOW_rready(S_AXI_LOW_rready),
        .S_AXI_LOW_rresp(S_AXI_LOW_rresp),
        .S_AXI_LOW_rvalid(S_AXI_LOW_rvalid),
        .S_AXI_LOW_wdata(S_AXI_LOW_wdata),
        .S_AXI_LOW_wlast(S_AXI_LOW_wlast),
        .S_AXI_LOW_wready(S_AXI_LOW_wready),
        .S_AXI_LOW_wstrb(S_AXI_LOW_wstrb),
        .S_AXI_LOW_wvalid(S_AXI_LOW_wvalid),
        .clause_addr_i(clause_addr_i),
        .clause_i(clause_i),
        .clause_o(clause_o),
        .clause_wren_i(clause_wren_i),
        .en_i(en_i),
        .reset_i(reset_i),
        .rst_busy_o(rst_busy_o));
endmodule
