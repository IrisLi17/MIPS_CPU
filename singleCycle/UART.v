module UART(sys_clk,cpu_clk,reset,rd,wr,addr,rdata,wdata,uart_rx,uart_tx);
input sys_clk;
input cpu_clk;
input reset;
input rd;
input wr;
input [31:0] addr;
output [31:0] rdata;
input [31:0] wdata;
input uart_rx;
output uart_tx;

wire gen_clk;
wire [7:0] uart_rxd;
reg [7:0] uart_txd;
reg [4:0] uart_con;
wire rx_sta;
wire tx_sta;
reg pre_tx_sta;
//wire tx_en;


baudgen myBaudgen(.sys_clk(sys_clk),.gen_clk(gen_clk));
receiver1 myReceiver(.uart_rx(uart_rx),.clk(gen_clk),.reset(reset),.rx_data(uart_rxd),.rx_status(rx_sta));
sender mySender(.tx_data(uart_txd),.clk(gen_clk),.reset(reset),.uart_tx(uart_tx),.tx_status(tx_sta),.tx_enable(uart_con[2]));
// assign uart_con[2] = uart_con[4];

assign rdata = rd?((addr == 32'h40000018)?{24'b0,uart_txd}:
                   ((addr == 32'h4000001c)?{24'b0,uart_rxd}:
                    (addr == 32'h40000020)?{27'b0,uart_con}:32'b0)):32'b0;


always @(posedge reset or posedge cpu_clk) begin
  if (reset) begin
    uart_con <= 5'b00011;
    pre_tx_sta <= 1'b0;
  end
  else begin
    pre_tx_sta <= tx_sta;
    if (rx_sta)  uart_con[3] <= 1'b1;
    if (tx_sta == 1'b0 && pre_tx_sta == 1'b1) begin
        uart_con[4] <= 1'b0;
        uart_con[2] <= 1'b0;
    end
    //uart_con[2] <= tx_en;
    if (wr) begin
        case(addr)
            32'h40000018: begin
                if (uart_con[0]&&(~uart_con[2])&&(~uart_con[4])) begin
                    uart_con[2] <= 1;
                    uart_con[4] <= 1;
                    uart_txd <= wdata[7:0];
                end
            end
            32'h40000020: uart_con <= wdata[4:0];
            default: ;
        endcase
    end
    else if (rd) begin
        case(addr)
            32'h4000001C: begin
                if (uart_con[1]&&uart_con[3]) begin
                    uart_con[3] <= 0;
                end
            end
            default: ;
        endcase
    end
  end
end
endmodule