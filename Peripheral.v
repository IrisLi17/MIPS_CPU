`timescale 1ns/1ps

module Peripheral (reset,clk,rd,wr,addr,wdata,rdata,led,switch,digi,irqout);
input reset,clk;
input rd,wr;
input [31:0] addr;
input [31:0] wdata;
// input uart_rx; //需要约束文件
// output uart_tx; //同上
output [31:0] rdata;
reg [31:0] rdata;

output [7:0] led;
reg [7:0] led;
input [7:0] switch;
output [11:0] digi;
reg [11:0] digi;
output irqout;

reg [31:0] TH,TL;
reg [2:0] TCON;
assign irqout = TCON[2];

// wire gen_clk;
// reg [7:0] uart_rxd;
// reg [7:0] uart_txd;
// reg [4:0] uart_con;
// baudgen myBaudgen(.sys_clk(clk),.gen_clk(gen_clk));
// receiver1 myReceiver(.uart_rx(uart_rx),.clk(gen_clk),.reset(reset),.rx_data(uart_rxd),.rx_status(uart_con[3]));
// sender mySender(.tx_data(uart_txd),.clk(gen_clk),.reset(reset),.uart_tx(uart_tx),.tx_status(uart_con[4]),.tx_enable(uart_con[2]));
// assign uart_con[2] = uart_con[4];
initial begin
  TCON[2] = 0;
end
always@(*) begin
	if(rd) begin
		case(addr)
			32'h40000000: rdata <= TH;			
			32'h40000004: rdata <= TL;			
			32'h40000008: rdata <= {29'b0,TCON};				
			32'h4000000C: rdata <= {24'b0,led};			
			32'h40000010: rdata <= {24'b0,switch};
			32'h40000014: rdata <= {20'b0,digi};
			// 32'h4000001C: begin
			//     if (uart_con[1]&&uart_con[3]) begin
			//         rdata <= {24'b0,uart_rxd};
			// 	    uart_con[3] <= 0;
			//     end
			// 	else rdata <= 32'b0;
		    // end
			// 32'h40000020: rdata <= {27'b0,uart_con};
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

always@(negedge reset or posedge clk) begin
	if(~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;	
		// uart_con <= 5'b00011;
	end
	else begin
		if(TCON[0]) begin	//timer is enabled
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1]) TCON[2] <= 1'b1;		//irq is enabled
			end
			else TL <= TL + 1;
		end
		
		if(wr) begin
			case(addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: digi <= wdata[11:0];
				// 32'h40000018: begin
				//     if (uart_con[0]&&(~uart_con[2])&&(~uart_con[4])) begin
				//         uart_con[2] <= 1;
				// 	    uart_txd <= wdata[7:0];
				//     end
				// end
				// 32'h40000020: uart_con <= wdata[4:0];
				default: ;
			endcase
		end
	end
end
endmodule

