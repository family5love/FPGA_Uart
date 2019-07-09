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



wire [ 7:0] rx_data;
uart_rx		inst_uart_rx(
	//system signal 
	.sclk(sclk),
 	.s_rst_n(s_rst_n),
	//uart_interface
 	.rs232_rx(rs232_rx),
	//others
	.rx_data(rx_data),
	.po_flag(po_flag)
);


uart_tx		inst_uart_tx(
	//system signals
	.sclk(sclk),
	.s_rst_n(s_rst_n),
	//Uart interface
	.rs232_tx(rs232_tx),
	//others
	.tx_trig(po_flag),
	.tx_data(rx_data)
);


timer_1s(
	//system signals
	.s_rst_n(s_rst_n),
	.sclk(sclk),
	//output signal
	.io_pin(led0)
);

endmodule
