`timescale 1ps/1ps
module pipeline_test;
reg clk;
//wire [7:0]led;
wire [7:0]switch;
wire [11:0]digi;
reg reset;
reg uart_rx;

wire uart_tx;
wire uart_rx_connect;
wire [7:0]temp1,temp2;

assign  uart_rx_connect = uart_rx;

initial
begin
  clk <= 1;
		reset <= 0;
		#10 reset <= 1;
		#50 reset <= 0;
		uart_rx <= 0;
end

initial	 begin forever
			#5 clk <= ~clk;
		end
initial	begin
			#150005 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;//起始位
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;//结束位
			#104165 uart_rx <= 1'b0;//起始位
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;//起始位
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;//起始位
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
		end

pipeline pipe(clk,reset,switch,digi,uart_rx,uart_tx,temp1,temp2);
endmodule
