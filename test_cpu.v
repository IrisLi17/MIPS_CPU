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
		reset <= 1;
		clk <= 1;
		switch <= 8'b10101010;
		uart_rx <= 0;
		#5000 reset <= 0;
	end
	initial fork
		forever begin
			#5 clk = ~clk;
		end
		forever begin
			#200 uart_rx <= 1'b0;
			#50 uart_rx <= 1'b0;
			#50 uart_rx <= 1'b0;
			#50 uart_rx <= 1'b0;
			#50 uart_rx <= 1'b1;
			#50 uart_rx <= 1'b0;
			#50 uart_rx <= 1'b1;
			#50 uart_rx <= 1'b1;
			#50 uart_rx <= 1'b0;
			#50 uart_rx <= 1'b1;
			
		end
	join
		
endmodule
