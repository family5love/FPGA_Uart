module uart(
	//System Signal
	input clk50M,
	input rst_n,
	
	input rxd,
	output txd,
	output reg led0
);

//LED��˸
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


//���ڽ����ֽں��������ͣ�����ģʽ���������ֽ�������������
wire rxd_flag;
wire [ 7:0] rxd_data;
uart_rxd u1_uart_rxd(
	//System signal
	.rst_n(rst_n),
	.clk50M(clk50M),
	//Uart rxd signal
	.rxd_pin(rxd),			//���ڽ��չܽ�
	.rxd_data(rxd_data),	//���ڽ��յ���1�ֽ�����
	.rxd_flag(rxd_flag)	//���ڽ���æΪ0�����ڽ�����Ϊ1�������ؽ���1�ֽ����
);

uart_txd u1_uart_txd(
	//System signal
	.clk50M(clk50M),
	.rst_n(rst_n),
	//Uart txd signal
	.txd_cmd(rxd_flag),	//�������������ڷ���
	.txd_data(rxd_data),	//���ڷ�������
	.txd_flag(txd_flag),	//���ڷ���æΪ0�����ڷ�����Ϊ1�������ط������
	.txd_pin(txd)			//���ڷ��͹ܽ�
);



endmodule 