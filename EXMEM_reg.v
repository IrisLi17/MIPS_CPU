module EXMEM_reg(clk,reset,EX_ALUout,Mem_in,
                 EX_MemWr,Mem_MemWr,
                 EX_MemRd,Mem_MemRd,
                 EX_BusB,Mem_BusB,
                 EX_RegWr,Mem_RegWr,
                 EX_MemtoReg,Mem_MemtoReg,
                 EX_RegDst,Mem_RegDst,
                 EX_WrReg,Mem_WrReg,
                 EX_PC,Mem_PC);
input clk,reset,EX_MemWr,EX_MemRd,EX_RegWr;
input[31:0]EX_ALUout,EX_BusB,EX_PC;
input[1:0]EX_MemtoReg,EX_RegDst;
input[4:0]EX_WrReg;
output reg[4:0]Mem_WrReg;
output reg[1:0]Mem_MemtoReg,Mem_RegDst;
output reg Mem_MemWr,Mem_MemRd,Mem_RegWr;
output reg [31:0]Mem_in,Mem_BusB,Mem_PC;
always@(posedge clk or posedge reset) begin
if(reset) begin
Mem_MemWr=0;
Mem_MemRd=0;
Mem_in=0;
Mem_BusB=0;
end
else begin
Mem_MemWr=EX_MemWr;
Mem_MemRd=EX_MemRd;
Mem_in=EX_ALUout;
Mem_BusB=EX_BusB;
Mem_MemtoReg=EX_MemtoReg;
Mem_WrReg=EX_WrReg;
Mem_RegWr=EX_RegWr;
Mem_RegDst=EX_RegDst;
Mem_PC=EX_PC;
end
end
endmodule
