module pipeline_ID(clk,reset,
                   ID_PC,ID_instruction,
                   IRQ,PCSrc,ID_rs,
                   ID_RegDst,ID_RegWr,
                   ID_ALUSrc1,ID_ALUSrc2,
                   ID_ALUFun,ID_Sign,
                   ID_MemWr,ID_MemRd,
                   ID_MemToReg,EXTOp,
                   LUOp,ConBA,JT,
                   ID_dataA, ID_dataB,
                   ALUout0,IDcontrol_jal,
                   WB_RegWr,ID_WrReg,
                   WB_Destiny,ID_rt,ID_rd,
                   WB_out,Mem_in,PCout,
                   ForwardC,ForwardD,
                   IDcontrol_Jump,IDcontrol_Branch,Branch,ID_shamt,ID_imm,
                   sp_monitor);
input IRQ,clk,reset,WB_RegWr,ForwardC,ForwardD;
input[31:0]ID_PC,ID_instruction,WB_out,Mem_in;
input[4:0]WB_Destiny;
output [31:0]PCout;
output[2:0]PCSrc;
output[1:0]ID_RegDst,ID_MemToReg;
output ID_RegWr,ID_Sign,ID_MemWr,ID_MemRd,EXTOp,LUOp;
output ALUout0;
output[5:0]ID_ALUFun;
output[31:0]ConBA;//branch??
output[31:0]ID_dataA,ID_dataB;
output[25:0]JT;//??jump??
output[4:0]ID_WrReg,ID_rt,ID_rd,ID_rs;
output IDcontrol_Jump,IDcontrol_Branch;
output Branch;
output IDcontrol_jal;
output ID_ALUSrc1, ID_ALUSrc2;
output [4:0] ID_shamt;
output [15:0] ID_imm; 
output [7:0] sp_monitor;

wire [31:0]data1,data2;
wire regWr;
assign JT=ID_instruction[25:0];
assign ID_imm=ID_instruction[15:0];
assign ID_rs=ID_instruction[25:21];
assign ID_rt=ID_instruction[20:16];
assign ID_rd=ID_instruction[15:11];
assign IDcontrol_jal= (ID_instruction[31:26]==3);
assign ID_shamt = ID_instruction[10:6];

Control control1(
		.Instruct(ID_instruction), .IRQ(IRQ), .PC31(ID_PC[31]), .PCSrc(PCSrc),
		.RegDst(ID_RegDst),.RegWr(regWr),.ALUSrc1(ID_ALUSrc1),.ALUSrc2(ID_ALUSrc2),
		.ALUFun(ID_ALUFun),.Sign(ID_Sign),.MemWr(ID_MemWr),.MemRd(ID_MemRd),
		.MemToReg(ID_MemToReg),.EXTOp(EXTOp),.LUOp(LUOp)
	);

RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(WB_RegWr), 
		.Read_register1(ID_instruction[25:21]), .Read_register2(ID_instruction[20:16]), .Write_register(WB_Destiny),
		.Write_data(WB_out), .Read_data1(data1), .Read_data2(data2),
        .sp_monitor(sp_monitor));

assign PCout=data1;
assign ID_RegWr=(ID_instruction==0) ? 0:regWr;
assign ConBA={14'b0,ID_imm,2'b00}+ID_PC;
assign ID_dataA=(ForwardC) ? Mem_in:data1;
assign ID_dataB=(ForwardD) ? Mem_in:data2;

assign ID_WrReg=(ID_instruction[31:26]==0) ? ID_rd:ID_rt;
//IDcontrol_Branch
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
assign IDcontrol_Jump=( (ID_instruction[31:26]==0 & (ID_instruction[5:0]==8 | ID_instruction[5:0]==9)) | 
                       (ID_instruction[31:26]==2 | ID_instruction[31:26]==3)) ? 1:0;
assign Branch=((ID_instruction[31:26]==1)|(ID_instruction[31:26]==4)|(ID_instruction[31:26]==5)|
               (ID_instruction[31:26]==6)|(ID_instruction[31:26]==7) )? 1:0;
assign IDcontrol_Branch=((ID_instruction[31:26]==1 & ID_dataA[31]==1) |//bltz
            (ID_instruction[31:26]==4 & ID_dataA==ID_dataB) |//beq
            (ID_instruction[31:26]==5 & ID_dataA!=ID_dataB) |//bne
            (ID_instruction[31:26]==6 & (ID_dataA[31]==1|ID_dataA==0) )     |//blez
            (ID_instruction[31:26]==7 & ID_dataA[31]==0 & ID_dataA!=0)) ? 1:0;//bgtz
assign ALUout0=(IDcontrol_Branch) ? 0:1;
endmodule
