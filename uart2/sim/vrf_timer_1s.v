`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:20:34 07/09/2019
// Design Name:   timer_1s
// Module Name:   D:/fengtao/study/ISE/Sdram_Controller/top/vrf_timer_1s.v
// Project Name:  top
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: timer_1s
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vrf_timer_1s;

	// Inputs
	reg s_rst_n;
	reg sclk;

	// Outputs
	wire io_pin;

	// Instantiate the Unit Under Test (UUT)
	timer_1s uut (
		.s_rst_n(s_rst_n), 
		.sclk(sclk), 
		.io_pin(io_pin)
	);

	initial begin
		// Initialize Inputs
		s_rst_n = 0;
		sclk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		s_rst_n = 1;

	end
	
	always #10 sclk = ~sclk;
      
endmodule

