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