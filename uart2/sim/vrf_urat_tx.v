`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:24:16 06/25/2019
// Design Name:   uart_tx
// Module Name:   D:/fengtao/study/ISE/Sdram_Controller/uart_tx/vrf_urat_tx.v
// Project Name:  uart_tx
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_tx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vrf_urat_tx;

	// Inputs
	reg sclk;
	reg s_rst_n;
	reg tx_trig;
	reg [7:0] tx_data;

	// Outputs
	wire rs232_tx;

	// Instantiate the Unit Under Test (UUT)
	uart_tx uut (
		.sclk(sclk), 
		.s_rst_n(s_rst_n), 
		.rs232_tx(rs232_tx), 
		.tx_trig(tx_trig), 
		.tx_data(tx_data)
	);

	initial begin
		// Initialize Inputs
		sclk = 0;
		s_rst_n = 0;
		tx_trig = 0;
		tx_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        s_rst_n = 1;
		// Add stimulus here
		
		#100;
		tx_data = 8'b0101_0101;
		tx_trig = 1;
		#100;
		tx_trig = 0;
		#1_000;
		tx_trig = 1;
		tx_data = 8'b0111_1111;
		#100;
		tx_trig = 0;
		

	end
	
	always #10 sclk = ~sclk;
      
endmodule

