`timescale 1ns / 1ps
module uart_txd(
	//System signal
	input clk50M,
	input rst_n,
	//Uart txd signal
	input txd_cmd,				//上升沿启动串口发送
	input [ 7:0] txd_data,		//串口发送数据
	output reg txd_flag,		//串口发送忙为0，串口发送闲为1，上升沿发送完成
	output reg txd_pin			//串口发送管脚
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
parameter [15:0] bit0 = 1*bit_width - 1;
parameter [15:0] bit1 = 2*bit_width - 1;
parameter [15:0] bit2 = 3*bit_width - 1;
parameter [15:0] bit3 = 4*bit_width - 1;
parameter [15:0] bit4 = 5*bit_width - 1;
parameter [15:0] bit5 = 6*bit_width - 1;
parameter [15:0] bit6 = 7*bit_width - 1;
parameter [15:0] bit7 = 8*bit_width - 1;
parameter [15:0] bit_stop = 9*bit_width - 1;//停止位
parameter [15:0] bit_stop_end = 10*bit_width - 1;//停止位结束

//txd_cmd打一拍
reg p_txd_cmd;
always @(posedge clk50M or negedge rst_n) begin
	if(~rst_n) begin
		p_txd_cmd <= 1;
	end
	else begin
		p_txd_cmd <= txd_cmd;
	end
end

//Main Function
//状态机参数
parameter [ 2:0] IDLE = 'd0;
parameter [ 2:0] SEND = 'd1;
reg [ 1:0] status;//状态机
reg [15:0] cnt;//计数器
reg [ 7:0] p_txd_data;
always @(posedge clk50M or negedge rst_n) begin
	if(~rst_n) begin
		cnt <= 16'd0;
		status <= IDLE;
		//output
		txd_flag <= 0;
		txd_pin <= 1;
	end
	else begin
		case(status)
			IDLE: begin
				if((~p_txd_cmd) & txd_cmd) begin//txd_cmd上升沿
					status <= SEND;
					p_txd_data <= txd_data;//存入待发送数据
					txd_flag <= 0;//串口发送忙
					txd_pin <= 0;//起始位
				end
				else begin
					status <= IDLE;
					txd_flag <= 1;//串口发送闲
					txd_pin <= 1;//空闲
				end
			end
			SEND: begin
				cnt <= cnt + 1;
				case(cnt)
					bit0: txd_pin <= p_txd_data[0];
					bit1: txd_pin <= p_txd_data[1];
					bit2: txd_pin <= p_txd_data[2];
					bit3: txd_pin <= p_txd_data[3];
					bit4: txd_pin <= p_txd_data[4];
					bit5: txd_pin <= p_txd_data[5];
					bit6: txd_pin <= p_txd_data[6];
					bit7: txd_pin <= p_txd_data[7];
					bit_stop: txd_pin <= 1;
					bit_stop_end: begin
						txd_flag <= 1;
						cnt <= 16'd0;
						status <= IDLE;
					end
				endcase
			end
		endcase
	end
end

endmodule







