module IFID_reg(clk,reset,stall,IFID_flush,instruction,IF_PC,ID_instruction,ID_PC);
input clk,reset,IFID_flush,stall;
input [31:0]IF_PC,instruction;
output reg[31:0]ID_PC,ID_instruction;
always@(posedge reset or posedge clk)
begin
if(reset) begin
ID_PC=32'h80000000;
ID_instruction=32'b0;
end
else begin
ID_PC= (stall) ? ID_PC:IF_PC;
ID_instruction= (stall) ? ID_instruction:
                (IFID_flush) ? 32'b0:instruction;
end
end
endmodule
