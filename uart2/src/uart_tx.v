//`define SIM
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:39:12 06/21/2019 
// Design Name: 
// Module Name:    uart_tx 
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
module uart_tx(
	//system signals
	input 				sclk,
	input 				s_rst_n,
	//Uart interface
	output reg 			rs232_tx,
	//others
	input 				tx_trig,
	input 		[7:0] 	tx_data
);

`ifndef SIM
localparam BAUD_END = 5207;
`else
localparam BAUD_END = 56;
`endif
localparam BAUD_M = BAUD_END/2 - 1;
localparam BIT_END = 8;

reg [ 7:0] 	tx_data_r;
reg 		tx_flag;
reg [12:0]	baud_cnt;
reg 		bit_flag;
reg [ 3:0]	bit_cnt;

//tx_data_r
always @(posedge sclk or negedge s_rst_n) begin
	if(~s_rst_n)
		tx_data_r <= 'd0;
	else if(tx_trig & (~tx_flag))
		tx_data_r <= tx_data;
end
//tx_flag
always @(posedge sclk or negedge s_rst_n) begin
	if(~s_rst_n)
		tx_flag <= 'b0;
	else if(tx_trig & (~tx_flag))
		tx_flag <= 'b1;
	else if(bit_cnt == BIT_END && bit_flag == 'b1)
		tx_flag <= 'b0;
end
//baud_cnt
always @(posedge sclk or negedge s_rst_n) begin
	if(~s_rst_n)
		baud_cnt <= 'd0;
	else if(baud_cnt == BAUD_END)
		baud_cnt <= 'd0;
	else if(tx_flag)
		baud_cnt <= baud_cnt + 'd1;
	else
		baud_cnt <= 'd0;
end
//bit_flag
always @(posedge sclk or negedge s_rst_n) begin
	if(~s_rst_n)
		bit_flag <= 'b0;
	else if(baud_cnt == BAUD_END)
		bit_flag <= 'b1;
	else
		bit_flag <= 'b0;
end
//bit_cnt
always @(posedge sclk or negedge s_rst_n) begin
	if(~s_rst_n)
		bit_cnt <= 'd0;
	else if(bit_flag & (bit_cnt == BIT_END))
		bit_cnt <= 'd0;
	else if(bit_flag)
		bit_cnt <= bit_cnt + 'd1;
end
//rs232_tx
always @(posedge sclk or negedge s_rst_n) begin
	if(~s_rst_n)
		rs232_tx <= 1'b1;
	else if(tx_flag)
		case(bit_cnt)
			'd0: 		rs232_tx <= 1'b0;
			'd1: 		rs232_tx <= tx_data_r[0];
			'd2: 		rs232_tx <= tx_data_r[1];
			'd3: 		rs232_tx <= tx_data_r[2];
			'd4: 		rs232_tx <= tx_data_r[3];
			'd5: 		rs232_tx <= tx_data_r[4];
			'd6: 		rs232_tx <= tx_data_r[5];
			'd7: 		rs232_tx <= tx_data_r[6];
			'd8: 		rs232_tx <= tx_data_r[7];
			default:	rs232_tx <= 1'b1;
		endcase
	else
		rs232_tx <= 1'b1;
end

endmodule
