`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:20:25 06/27/2019
// Design Name:   top
// Module Name:   D:/fengtao/study/ISE/Sdram_Controller/top/vrf_top.v
// Project Name:  top
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vrf_top;

	// Inputs
	reg s_rst_n;
	reg sclk;
	reg rs232_rx;

	// Outputs
	wire rs232_tx;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.s_rst_n(s_rst_n), 
		.sclk(sclk), 
		.rs232_rx(rs232_rx), 
		.rs232_tx(rs232_tx)
	);

	initial begin
		// Initialize Inputs
		s_rst_n = 0;
		sclk = 0;
		rs232_rx = 1;

		// Wait 100 ns for global reset to finish
		#100;
        s_rst_n = 1;
		// Add stimulus here
		
		#1000;
		//start
		rs232_rx = 0;
		#104166;
		//data
		rs232_rx = 1;
		#104166;
		rs232_rx = 0;
		#104166;
		rs232_rx = 1;
		#104166;
		rs232_rx = 0;
		#104166;
		rs232_rx = 1;
		#104166;
		rs232_rx = 0;
		#104166;
		rs232_rx = 1;
		#104166;
		rs232_rx = 0;
		#104166;
		//stop
		rs232_rx = 1;		
	end
	
    always #10 sclk = ~sclk;
 

	
endmodule

