module baudgen(sys_clk,gen_clk);
input sys_clk;
output gen_clk;
reg [9:0] counter;
reg gen;
assign gen_clk = gen;

initial begin
    counter<=10'd0;
end

always @(posedge sys_clk) begin
  case (counter)
    10'd650: begin
      counter<=10'd0;
      gen <= 1'b1;
    end
    default: begin
      counter <= counter+10'd1;
      gen <= 1'b0;
    end
  endcase
end
endmodule