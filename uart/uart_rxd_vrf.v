`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:57:32 04/30/2019
// Design Name:   uart_rxd
// Module Name:   D:/fengtao/study/ISE/uart/uart_rxd_vrf.v
// Project Name:  uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_rxd
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_rxd_vrf;

	// Inputs
	reg rst_n;
	reg clk50M;
	reg rxd_pin;

	// Outputs
	wire [7:0] rxd_data;
	wire rxd_flag;

	// Instantiate the Unit Under Test (UUT)
	uart_rxd uut (
		.rst_n(rst_n), 
		.clk50M(clk50M), 
		.rxd_pin(rxd_pin), 
		.rxd_data(rxd_data), 
		.rxd_flag(rxd_flag)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk50M = 0;
		rxd_pin = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst_n = 1;
		rxd_pin = 1;
		// Add stimulus here
		
		#1000;
		
		//起始位
		rxd_pin = 0;
		#104167;
		//bit0 
		rxd_pin = 1;
		#104167;
		//bit1
		rxd_pin = 0;
		#104167;
		//bit2 
		rxd_pin = 1;
		#104167;
		//bit3
		rxd_pin = 0;
		#104167;
		//bit4 
		rxd_pin = 1;
		#104167;
		//bit5 
		rxd_pin = 0;
		#104167;
		//bit6 
		rxd_pin = 1;
		#104167;
		//bit7 
		rxd_pin = 0;
		#104167;
		//停止位
		rxd_pin = 1;
		
	end
   
	always #10 clk50M = ~clk50M;
	
endmodule



