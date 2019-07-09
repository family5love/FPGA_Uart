`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:02:25 04/29/2019 
// Design Name: 
// Module Name:    uart_rxd 
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
module uart_rxd(
	//Syatem signal
	input rst_n,
	input clk50M,
	//Uart rxd signal
	input rxd_pin,
	output reg [7:0] rxd_data,
	output reg rxd_flag
);

//各种波特率计数值
parameter [15:0] bps_9600 = 5208;
parameter [15:0] bps_14400 = 3472;
parameter [15:0] bps_19200 = 2604;
parameter [15:0] bps_38400 = 1302;
parameter [15:0] bps_56000 = 893;
parameter [15:0] bps_115200 = 434;
//波特率1bit计数值
parameter [15:0] bit_width = bps_9600;//波特率设置
//各个bit计数值
parameter [15:0] bit0 = 1*bit_width + bit_width/2 - 1;
parameter [15:0] bit1 = 2*bit_width + bit_width/2 - 1;
parameter [15:0] bit2 = 3*bit_width + bit_width/2 - 1;
parameter [15:0] bit3 = 4*bit_width + bit_width/2 - 1;
parameter [15:0] bit4 = 5*bit_width + bit_width/2 - 1;
parameter [15:0] bit5 = 6*bit_width + bit_width/2 - 1;
parameter [15:0] bit6 = 7*bit_width + bit_width/2 - 1;
parameter [15:0] bit7 = 8*bit_width + bit_width/2 - 1;
//parameter [15:0] bit_stop_end = 9*bit_width + bit_width/2 - 1;//停止位
parameter [15:0] bit_stop_end = 10*bit_width - 1;//停止位

//rxd_pin打一拍
reg p_rxd_pin;
always @(posedge clk50M or negedge rst_n) begin
	if(~rst_n) begin
		p_rxd_pin <= 1;
	end
	else begin
		p_rxd_pin <= rxd_pin;
	end
end

//Main Function 
//状态机参数
parameter [ 2:0] IDLE = 'd0;
parameter [ 2:0] RCV = 'd1;
reg [ 1:0] status;//状态机
reg [15:0] cnt;//计数器
always @(posedge clk50M or negedge rst_n) begin
	if(~rst_n) begin
		status <= IDLE;
		cnt <= 0;
		rxd_data <= 8'h00;
		rxd_flag <= 1;
	end
	else begin
		case(status)
			IDLE: begin
				/*
				if(p_rxd_pin & (~rxd_pin)) begin//起始位
					status <= RCV;
					rxd_flag <= 0;//串口接收忙
				end
				else begin
					status <= IDLE;
				end
				*/
				if(p_rxd_pin) begin
					status <= IDLE;
				end
				else begin
					status <= RCV;
					rxd_flag <= 0;//串口接收忙
				end
			end
			RCV: begin
				cnt <= cnt + 1;
				case(cnt)
					bit0: rxd_data[0] <= p_rxd_pin;
					bit1: rxd_data[1] <= p_rxd_pin;
					bit2: rxd_data[2] <= p_rxd_pin;
					bit3: rxd_data[3] <= p_rxd_pin;
					bit4: rxd_data[4] <= p_rxd_pin;
					bit5: rxd_data[5] <= p_rxd_pin;
					bit6: rxd_data[6] <= p_rxd_pin;
					bit7: rxd_data[7] <= p_rxd_pin;
					bit_stop_end: begin
						cnt <= 16'd0;
						rxd_flag <= 1;
						status <= IDLE;
					end
				endcase
			end
		endcase
	end
end

endmodule









