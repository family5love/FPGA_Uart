# uart2：第二种uart实现（参考[邓堪文博客](http://dengkanwen.com/273.html)）
## 编译环境
>ISE14.7

## FPGA
> XC6SLX9

## 实现功能：
> 接收到一个字节串口数据后立即发送出去。（并包含一个led闪烁，T = 1s）

## 文件夹:uart2
包含文件：

> 1) top.v

> 2) top.ucf

> 3) uart_rx.v

> 4) uart_tx.v

> 5) timer_1s.v