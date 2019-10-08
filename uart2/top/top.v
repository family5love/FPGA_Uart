`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:06:01 06/27/2019 
// Design Name: 
// Module Name:    top 
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
module top(
	//syatem signal
	input s_rst_n,
	input sclk,
	//UART interface
	input rs232_rx,
	output rs232_tx,
	//LED0 io
	output led0
);


wire clk_50M;
wire clk_200M;
wire pll_locked;
wire [ 7:0] rx_data;

//实例化：锁相环IP
pll_ip	pll_ip_inst(
	.RESET(~s_rst_n),
	.CLK_IN1(sclk),
	.CLK_OUT1(clk_50M),
	.CLK_OUT2(clk_200M),
	.LOCKED(pll_locked)
);

//实例化：串口接收模块
uart_rx		inst_uart_rx(
	//system signal 
	.sclk(clk_50M),
 	.s_rst_n(s_rst_n),
	//uart_interface
 	.rs232_rx(rs232_rx),
	//others
	.rx_data(rx_data),
	.po_flag(po_flag)
);

//实例化：串口发送模块
uart_tx		inst_uart_tx(
	//system signals
	.sclk(clk_50M),
	.s_rst_n(s_rst_n),
	//Uart interface
	.rs232_tx(rs232_tx),
	//others
	.tx_trig(po_flag),
	.tx_data(rx_data)
);

//实例化：
timer_1s	timer_1s_inst(
	//system signals
	.s_rst_n(s_rst_n),
	.sclk(clk_200M),
	//output signal
	.io_pin(led0)
);

endmodule
