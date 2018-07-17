module cpu_clk(sys_clk,clk);
input sys_clk;
output reg clk;

initial begin;
  clk<=0;
end

always @(posedge sys_clk) begin
   clk<=~clk;
end

endmodule