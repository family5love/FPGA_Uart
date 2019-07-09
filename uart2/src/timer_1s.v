`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:13:41 07/09/2019 
// Design Name: 
// Module Name:    timer_1s 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module timer_1s(
	//system signals
	input s_rst_n,
	input sclk,
	//output signal
	output io_pin
);

	reg [25:0] num;
	always @(posedge sclk or negedge s_rst_n) begin
		if(~s_rst_n)
			num <= 'd0;
		else if(num == 'd50_000_000)
			num <= 'd0;
		else
			num <= num + 'd1;
	end
	
	assign io_pin = (num >= 'd25_000_000) ?  'b1 : 'b0;

endmodule
