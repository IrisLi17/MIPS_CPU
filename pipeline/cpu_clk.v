module cpu_clk(sys_clk,clk);
input sys_clk;
output reg clk;
reg [25:0] counter;

initial begin
  counter<=26'd0;
  clk<=0;
end

always @(posedge sys_clk) begin
  case (counter)
    26'b11111111: begin
      counter<=26'd0;
      clk<=~clk;
    end
    default: begin
      counter <= counter + 3'd1;
    end
  endcase
end

endmodule