module pipeline_ID(clk,reset,ID_PC,ID_instruction,IRQ,PCSrc,ID_RegDst,ID_RegWr,ALUSrc1,ALUSrc2,ID_ALUFun,ID_Sign,ID_MemWr,ID_MemRd,
ID_MemToReg,EXTOp,LUOp,ConBA,JT,ID_BusA,ID_BusB,IFID_flush,ALUout0,WB_RegWr,ID_WrReg,WB_WrReg,ID_rt,ID_rd,WB_out);
input IRQ,clk,reset,WB_RegWr;
input[31:0]ID_PC,ID_instruction,WB_out;
input[4:0]WB_WrReg;
output[2:0]PCSrc;
output[1:0]ID_RegDst,ID_MemToReg;
output ID_RegWr,ALUSrc1,ALUSrc2,ID_Sign,ID_MemWr,ID_MemRd,EXTOp,LUOp;
output IFID_flush,ALUout0;
output[5:0]ID_ALUFun;
output[31:0]ConBA;//branch??
output[31:0]ID_BusA,ID_BusB;
output[25:0]JT;//??jump??
output[4:0]ID_WrReg,ID_rt,ID_rd;

wire [4:0]shamt;
wire [31:0]data1,data2,immidiate;
wire [15:0]imm;
assign JT=ID_instruction[25:0];
assign imm=ID_instruction[15:0];
assign ID_rt=ID_instruction[20:16];
assign ID_rd=ID_instruction[15:11];

Control control1(
		.ID_instruction(Instruction), .IRQ(IRQ), .PC31(ID_PC[31]), .PCSrc(PCSrc),
		.RegDst(ID_RegDst),.RegWr(ID_RegWr),.ALUSrc1(ALUSrc1),.ALUSrc2(ALUSrc2),
		.ALUFun(ID_ALUFun),.Sign(ID_Sign),.MemWr(ID_MemWr),.MemRd(ID_MemRd),
		.MemToReg(ID_MemToReg),.EXTOp(EXTOp),.LUOp(LUOp)
	);

RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(WB_RegWr), 
		.Read_register1(ID_instruction[25:21]), .Read_register2(ID_instruction[20:16]), .Write_register(WB_WrReg),
		.Write_data(WB_out), .Read_data1(data1), .Read_data2(data2));

assign ConBA={14'b0,imm,2'b00}+ID_PC+4;
assign immidiate=LUOp ? {imm,16'b0}:
          EXTOp ? {{16{imm[15]}},imm} : {16'b0,imm};
assign ID_BusA=ALUSrc1 ? {27'b0,shamt} : data1;
assign ID_BusB=ALUSrc2 ? immidiate : data2;
assign ID_WrReg=(ID_instruction[31:26]==0) ? ID_rd:ID_rt;
//IFID_flush
/*always @(*) begin
if(reset) 
IFID_flush=0;
else case(ID_instruction[31:26])
6'd1: IFID_flush=(data1[31]==1)? 1:0;//bltz
6'd4: IFID_flush=(data1==data2)? 1:0;//beq
6'd5: IFID_flush=(data1==data2)? 0:1;//bne
6'd6: IFID_flush=(data1[31]==1 | data1==0) ?1:0;//blez
6'd7: IFID_flush=(data1>0) ?1:0;//bgtz
default:IFID_flush=0;
endcase
ALUout0=(IFID_flush)? 1:PCSrc;
end */
assign IFID_flush=((ID_instruction[31:26]==1 & data1[31]==1) |//bltz
            (ID_instruction[31:26]==4 & data1==data2) |//beq
            (ID_instruction[31:26]==5 & data1!=data2) |//bne
            (ID_instruction[31:26]==6 & data1<=0)     |//blez
            (ID_instruction[31:26]==7 & data1>0)) ? 1:0;//bgtz
assign ALUout0=(IFID_flush) ? 0:1;
endmodule
