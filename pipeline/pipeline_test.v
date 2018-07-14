`timescale 1ps/1ps
module pipeline_test;
reg clk;
wire [7:0]led,switch;
reg reset;
reg uart_rx;

wire uart_tx;
wire uart_rx_connect;

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
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b1;
			#104165 uart_rx <= 1'b0;
			#104165 uart_rx <= 1'b1;
		end

pipeline pipe(clk,reset,led,switch,uart_rx,uart_tx);
endmodule
