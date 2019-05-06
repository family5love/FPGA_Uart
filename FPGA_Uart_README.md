# FPGA内实现串口收发

> 编译环境：ISE14.7

> FPGA型号：XC6SLX9

> 实现功能：接收到一个字节串口数据后立即发送出去。

> 代码实现方式：
> 1. 一个串口接收模块uart_rxt；
> 2. 一个串口发送模块uart_txt；
> 3. 收发模块uart，将uart_rxt接收完成标志作为uart_txt的串口发送标志，完成即收即发功能。

# 存在的问题
> 本程序仅仅作为FPGA串口实现的简单验证程序，一次连续接收多个字节（9600bps，18个字节以上）可能会出错。
# 改进方案
> 可考虑在接在收发模块uart中加入FIFO，缓冲串口收发的数据。
# 代码
> 压缩文件uart.rar为在ISE中实现的工程文件。

## uart_rxd模块代码：

```verilog
`timescale 1ns / 1ps
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
```
## uart_txd模块代码：
```verilog
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
```

## uart模块代码：
```verilog
module uart(
	//System Signal
	input clk50M,
	input rst_n,
	
	input rxd,
	output txd,
	output reg led0
);

//LED闪烁
reg [31:0] n;
always @(posedge clk50M or negedge rst_n) begin
	if(~rst_n) begin
		n <= 0;
		led0 <= 0;
	end
	else begin
		if(n == 32'd25_000_000) begin
			n <= 0;
			led0 <= ~ led0;
		end
		else begin
			n <= n + 1;
		end
	end	
end


//串口接收字节后立即发送，此种模式连续接收字节数量过多会出错
wire rxd_flag;
wire [ 7:0] rxd_data;
uart_rxd u1_uart_rxd(
	//System signal
	.rst_n(rst_n),
	.clk50M(clk50M),
	//Uart rxd signal
	.rxd_pin(rxd),			//串口接收管脚
	.rxd_data(rxd_data),	//串口接收到的1字节数据
	.rxd_flag(rxd_flag)	//串口接收忙为0，串口接收闲为1，上升沿接收1字节完成
);

uart_txd u1_uart_txd(
	//System signal
	.clk50M(clk50M),
	.rst_n(rst_n),
	//Uart txd signal
	.txd_cmd(rxd_flag),	//上升沿启动串口发送
	.txd_data(rxd_data),	//串口发送数据
	.txd_flag(txd_flag),	//串口发送忙为0，串口发送闲为1，上升沿发送完成
	.txd_pin(txd)			//串口发送管脚
);



endmodule 
```