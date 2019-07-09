`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:24:07 06/04/2019
// Design Name:   uart_rx
// Module Name:   D:/fengtao/study/ISE/Sdram_Controller/uart_rx/uart_rx_vrf.v
// Project Name:  uart_rx
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_rx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_rx_vrf;

	// Inputs
	reg sclk;
	reg s_rst_n;
	reg rs232_rx;

	// Outputs
	wire [7:0] rx_data;
	wire po_flag;
	
	reg [7:0] mem_a[3:0];
	// Instantiate the Unit Under Test (UUT)
	uart_rx uut (
		.sclk(sclk), 
		.s_rst_n(s_rst_n), 
		.rs232_rx(rs232_rx), 
		.rx_data(rx_data), 
		.po_flag(po_flag)
	);

	initial begin
		// Initialize Inputs
		sclk = 0;
		s_rst_n = 0;
		rs232_rx = 1;

		// Wait 100 ns for global reset to finish
		#100;
		s_rst_n = 1;
		#1_100;
        rx_byte();
		// Add stimulus here

	end

	initial $readmemh("./tx_data.txt", mem_a);

	always #5 sclk = ~sclk;

	task rx_bit(
		input [7:0] data
	);
		integer i;
		for (i = 0; i < 10; i = i + 1) begin
			case(i)
				0: rs232_rx <= 1'b0;
				1: rs232_rx <= data[0];
				2: rs232_rx <= data[1]; 
				3: rs232_rx <= data[2];
				4: rs232_rx <= data[3];
				5: rs232_rx <= data[4];
				6: rs232_rx <= data[5];
				7: rs232_rx <= data[6];
				8: rs232_rx <= data[7];
				9: rs232_rx <= 1'b1;
			endcase
			#560;
		end
	endtask

	task rx_byte();
		integer i;
		for(i = 0; i < 4; i = i + 1) begin
			rx_bit(mem_a[i]);
		end
	endtask
endmodule

