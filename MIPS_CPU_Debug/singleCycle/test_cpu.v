`timescale 1ns/1ps
module test_cpu();
	
	reg reset;
	reg clk;
	reg [7:0] switch; //不知道是用来干什么的
	reg uart_rx;
	wire [7:0] led;
	wire [11:0] digi;
	wire uart_tx;
	
	CPU cpu1(reset, clk, led, switch, digi, uart_rx, uart_tx);
	
	initial begin
		reset <= 0;
		#10 reset <= 1;
		#50 reset <= 0;
		clk <= 1;
		switch <= 8'b10101010;
		uart_rx <= 0;
		//#500000 reset <= 1;
	end
	initial fork
		forever begin
			#5 clk = ~clk;
		end
		begin
			#150005 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;//起始位
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;//结束位
			#104165 uart_rx <= 1'b0;//起始位
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
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
	join
		
endmodule
