
`timescale 1 ns / 1 ps

	module Clause_Buffer #
	(
		// Users to add parameters here
        parameter integer CLAUSE_WIDTH = 36,
        parameter integer CLAUSE_DEPTH = 2048,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
        input   wire [$clog2(CLAUSE_DEPTH) - 1 : 0] clause_address_i,
        input   wire [CLAUSE_WIDTH  - 1 : 0] clause_i,
        input   wire clause_wren_i,
        output  wire [CLAUSE_WIDTH  - 1 : 0] clause_o,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
	
	wire [$clog2(CLAUSE_DEPTH) - 1 : 0] data_address_o;
    wire [31:0] data_low_i;
    wire [31:0] data_high_i;
    wire wren_low_o;
    wire wren_high_o;
    wire [31:0] data_low_o;
    wire [31:0] data_high_o;
    
// Instantiation of Axi Bus Interface S00_AXI
	Clause_Buffer_slave_lite_v1_0_S00_AXI # ( 
	    .CLAUSE_DEPTH(CLAUSE_DEPTH),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) Clause_Buffer_slave_lite_v1_0_S00_AXI_inst (
	    .data_address_o(data_address_o),
	    .data_low_i(data_low_i),
	    .data_high_i(data_high_i),
	    .wren_low_o(wren_low_o),
	    .wren_high_o(wren_high_o),
	    .data_low_o(data_low_o),
	    .data_high_o(data_high_o),
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here
    Clause_memory # (
        .CLAUSE_WIDTH(CLAUSE_WIDTH),
        .CLAUSE_DEPTH(CLAUSE_DEPTH)
    ) Clause_memory_inst (
        .clk_i(s00_axi_aclk),
        .rst_i(s00_axi_aresetn),
        // axi side I/O
        .data_address_i(data_address_o),
        .data_low_i(data_low_o),
        .data_high_i(data_high_o),
        .wren_low_i(wren_low_o),
        .wren_high_i(wren_high_o),
        .data_low_o(data_low_i),
        .data_high_o(data_high_i),
        
        // PL side I/O
        .clause_address_i(clause_address_i),
        .clause_i(clause_i),
        .clause_wren_i(clause_wren_i),
        .clause_o(clause_o)
    );
    // User logic ends

	endmodule
