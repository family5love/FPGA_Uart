`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:28:26 04/29/2019
// Design Name:   uart_txd
// Module Name:   D:/fengtao/study/ISE/uart/uart_txd_vrf.v
// Project Name:  uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_txd
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_txd_vrf;

	// Inputs
	reg clk50M;
	reg rst_n;
	
	reg txd_cmd;
	reg [7:0] txd_data;

	// Outputs
	wire txd_flag;
	wire txd_pin;

	// Instantiate the Unit Under Test (UUT)
	uart_txd uut (
		.clk50M(clk50M), 
		.rst_n(rst_n), 
		.txd_cmd(txd_cmd), 
		.txd_data(txd_data), 
		.txd_flag(txd_flag), 
		.txd_pin(txd_pin)
	);

	initial begin
		// Initialize Inputs
		clk50M = 0;
		rst_n = 0;
		txd_cmd = 0;
		txd_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst_n = 1;
		txd_data	= 8'h55;
		// Add stimulus here
		#1000;
		txd_cmd = 1;
	end
	
	always #10 clk50M = ~clk50M;
      
endmodule

