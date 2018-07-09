module cpu_clk(sys_clk,clk);
input sys_clk;
output reg clk;
reg [2:0] counter;

initial begin
  counter<=3'd0;
  clk<=0;
end

always @(posedge sys_clk) begin
  case (counter)
    3'b111: begin
      counter<=3'd0;
      clk<=1;
    end
    default: begin
      counter <= counter + 3'd1;
      clk <= 0;
    end
  endcase
end

endmodule