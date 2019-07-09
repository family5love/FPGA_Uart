//`define SIM
`timescale 1ns / 1ps
module uart_rx(
	//system signal 
	input sclk,
	input s_rst_n,
	//uart_interface
	input rs232_rx,
	//others
	output reg [ 7: 0]  rx_data,
	output reg          po_flag
);
//===============================================================parameter
`ifndef SIM
localparam BAUD_END = 5207;
`else
localparam BAUD_END = 56;
`endif
localparam BAUD_M   = BAUD_END/2 - 1;
localparam BIT_END  = 8;
reg         rx_r1;
reg         rx_r2;
reg         rx_r3;
reg         rx_flag;
reg [13:0]  baud_cnt;
reg         bit_flag;
reg [ 3:0]  bit_cnt;

wire        rx_neg;
//===============================================================rx_neg

assign rx_neg =(~rx_r2) & rx_r3;
always @(posedge sclk) begin
    rx_r1 <= rs232_rx;
    rx_r2 <= rx_r1;
    rx_r3 <= rx_r2;
end
//===============================================================rx_flag
always @(posedge sclk or negedge s_rst_n) begin
    if(~ s_rst_n)
        rx_flag <= 1'b0;
    else if(rx_neg)
        rx_flag <= 1'b1;
    else if(bit_cnt == 'd0 && baud_cnt == BAUD_END)
        rx_flag <= 1'b0;
    else
        rx_flag <= rx_flag;
end
//================================================================baud_cnt
always @(posedge sclk or negedge s_rst_n) begin
    if(~s_rst_n)
        baud_cnt <= 'd0;
    else if(baud_cnt == BAUD_END)
        baud_cnt <= 'd0;
    else if(rx_flag)
        baud_cnt <= baud_cnt + 'd1;
    else 
        baud_cnt <= 'd0;
end
//================================================================bit_flag
always @(posedge sclk or negedge s_rst_n) begin
    if(~s_rst_n)
        bit_flag <= 1'b0;
    else if(baud_cnt == BAUD_M)
        bit_flag <= 1'b1;
    else 
        bit_flag <= 1'b0;
end
//================================================================bit_cnt
always @(posedge sclk or negedge s_rst_n) begin
    if(~s_rst_n)
        bit_cnt <= 'd0;
    else if(bit_flag == 1 && bit_cnt == BIT_END)
        bit_cnt <= 'd0;
    else if(bit_flag == 1)
        bit_cnt <= bit_cnt + 'd1;
    else 
        bit_cnt <= bit_cnt;
end
//================================================================rx_data
always @(posedge sclk or negedge s_rst_n) begin
    if(~s_rst_n)
        rx_data <= 'd0;
    else if(bit_flag == 1'b1 && bit_cnt >= 1)
        rx_data <= {rx_r2, rx_data[7:1]};
    else
        rx_data <= rx_data;
end
//================================================================po_flag
always @(posedge sclk or negedge s_rst_n) begin
    if(~s_rst_n)
        po_flag <= 1'b0;
    else if(bit_cnt == BIT_END && bit_flag == 1'b1)
        po_flag <= 1'b1;
    else 
        po_flag <= 1'b0;
end
endmodule
