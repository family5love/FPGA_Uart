`timescale 1ns / 1ps
module uart_txd(
	//System signal
	input clk50M,
	input rst_n,
	//Uart txd signal
	input txd_cmd,				//�������������ڷ���
	input [ 7:0] txd_data,		//���ڷ�������
	output reg txd_flag,		//���ڷ���æΪ0�����ڷ�����Ϊ1�������ط������
	output reg txd_pin			//���ڷ��͹ܽ�
);

//���ֲ����ʼ���ֵ
parameter [15:0] bps_9600 = 5208;
parameter [15:0] bps_14400 = 3472;
parameter [15:0] bps_19200 = 2604;
parameter [15:0] bps_38400 = 1302;
parameter [15:0] bps_56000 = 893;
parameter [15:0] bps_115200 = 434;
//������1bit����ֵ
parameter [15:0] bit_width = bps_9600;//����������
//����bit����ֵ
parameter [15:0] bit0 = 1*bit_width - 1;
parameter [15:0] bit1 = 2*bit_width - 1;
parameter [15:0] bit2 = 3*bit_width - 1;
parameter [15:0] bit3 = 4*bit_width - 1;
parameter [15:0] bit4 = 5*bit_width - 1;
parameter [15:0] bit5 = 6*bit_width - 1;
parameter [15:0] bit6 = 7*bit_width - 1;
parameter [15:0] bit7 = 8*bit_width - 1;
parameter [15:0] bit_stop = 9*bit_width - 1;//ֹͣλ
parameter [15:0] bit_stop_end = 10*bit_width - 1;//ֹͣλ����

//txd_cmd��һ��
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
//״̬������
parameter [ 2:0] IDLE = 'd0;
parameter [ 2:0] SEND = 'd1;
reg [ 1:0] status;//״̬��
reg [15:0] cnt;//������
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
				if((~p_txd_cmd) & txd_cmd) begin//txd_cmd������
					status <= SEND;
					p_txd_data <= txd_data;//�������������
					txd_flag <= 0;//���ڷ���æ
					txd_pin <= 0;//��ʼλ
				end
				else begin
					status <= IDLE;
					txd_flag <= 1;//���ڷ�����
					txd_pin <= 1;//����
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







