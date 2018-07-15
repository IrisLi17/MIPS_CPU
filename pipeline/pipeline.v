module pipeline(clk,reset,led,switch,digi,uart_rx,uart_tx);
input reset;
input uart_rx;
input [7:0]switch;
output uart_tx;
output [7:0]led;
output [11:0]digi;

input clk;
wire reset;
wire stall;
wire ALUOut0;
wire [2:0]PCSrc;
wire [31:0]ConBA;
wire [31:0]PC;
wire [31:0]IF_PC;
wire [25:0]JT;
wire [1:0]ForwardA;
wire [1:0]ForwardB;
wire ForwardC;
wire ForwardD;
wire Branch;

wire IFID_flush;
wire [31:0]instruction;

wire [31:0]ID_instruction;
wire [31:0]ID_PC;
wire [1:0]ID_RegDst;
wire ID_RegWr;
wire ALUSrc1;
wire ALUSrc2;
wire [5:0]ID_ALUFun;
wire ID_Sign;
wire ID_MemWr;
wire ID_MemRd;
wire [1:0]ID_MemToReg;
wire EXTOp;
wire LUOp;
wire [4:0]ID_WrReg;
wire [4:0]ID_rt;
wire [4:0]ID_rd;
wire [4:0]ID_rs;
wire IDcontrol_Jump;
wire IDcontrol_Branch;

wire EX_MemWr;
wire EX_RegWr;
wire EX_MemRd;
wire [5:0]EX_ALUFun;
wire [1:0]EX_RegDst;
wire [1:0]EX_MemtoReg;
wire [4:0]EX_WrReg;
wire [31:0]EX_PC;
wire [4:0]EX_rt;
wire [4:0]EX_rd;
wire [4:0]EX_rs;
wire [31:0]EX_ALUOut;
wire EX_Sign;

wire [31:0]Mem_in;
wire Mem_MemWr;
wire Mem_MemRd;
wire [31:0]Mem_BusB;
wire Mem_RegWr;
wire [1:0]Mem_MemtoReg;
wire [1:0]Mem_RegDst;
wire [4:0]Mem_WrReg;
wire [31:0]Mem_PC;
wire [4:0]Mem_rt;
wire [4:0]Mem_rd;
wire [31:0]Mem_outA;
wire [31:0]Mem_outB;

wire [7:0]led;
wire [7:0]switch;
wire [11:0]digi;
wire irqout;
wire uart_rx;
wire uart_tx;

wire WB_RegWr;
wire [4:0]WB_WrReg;
wire [31:0]WB_out;
wire [31:0]WB_inB;
wire [31:0]WB_inA;
wire [1:0]WB_RegDst;
wire [1:0]WB_MemtoReg;
wire [31:0]WB_PC;
wire [4:0]WB_rd;
wire [4:0]WB_Destiny;
wire IDcontrol_jal;
wire EXcontrol_jal;
wire Memcontrol_jal;
wire [31:0]PCout;
wire ForwardPC;
wire [31:0]EX_Memin;
wire [31:0]ID_Memin;
Hazard_Unit  Hazard(.reset(reset),.clk(clk),.ID_EX_MemRd(EX_MemRd),.ID_EX_RegRt(EX_rt),.ID_EX_RegRd(EX_rd),
                    .ID_EX_RegWrite(EX_RegWr),.ID_EX_RegDst_0(EX_RegDst[0]),.IF_ID_RegRs(ID_rs),
                    .IF_ID_RegRt(ID_rt),.IDcontrol_Branch(IDcontrol_Branch),.IDcontrol_Jump(IDcontrol_Jump),  
                    .ID_EX_Clear(stall),.IF_ID_Clear(IFID_flush),.Branch(Branch),.irq(irqout)
);

wire Forwardsw;

Forward_Unit Forward(.clk(clk),.reset(reset),.EX_MEM_RegWrite(Mem_RegWr),.EX_MEM_RegRd(Mem_WrReg),.ID_EX_RegRs(EX_rs),
                     .ID_EX_RegRt(EX_rt),.MEM_WB_RegWrite(WB_RegWr),.MEM_WB_RegRd(WB_WrReg),.IDControl_Branch(Branch),
                     .IF_ID_RegRs(ID_rs),.IF_ID_RegRt(ID_rt),.Memcontrol_jal(Memcontrol_jal),.PCSrc(PCSrc),
                     .ForwardA(ForwardA),.ForwardB(ForwardB),.ForwardC(ForwardC),.ForwardD(ForwardD),.ForwardPC(ForwardPC),.Forwardsw(Forwardsw),
                     .EX_MEM_MEMWrite(Mem_MemWr),.EX_MEM_RegRt(Mem_rt),.MEM_WB_Reg(WB_WrReg));

pipeline_IF IF_pipeline(.clk(clk),.reset(reset),.stall(stall),.PCSrc(PCSrc),.ConBA(ConBA),.ForwardPC(ForwardPC),
                        .ALUOut0(ALUOut0),.ID_BusA(PCout),.PC(PC),.IF_PC(IF_PC),.JT(JT),.MEM_PC(Mem_PC));

InstructionMemory MemoryInstruction(.Address(PC), .Instruction(instruction));

IFID_reg reg_IFID(.clk(clk),.reset(reset),.stall(stall),.IFID_flush(IFID_flush),
                  .instruction(instruction),.IF_PC(IF_PC),.ID_instruction(ID_instruction),.ID_PC(ID_PC));

wire [31:0] ID_dataA, ID_dataB;
wire [4:0] ID_shamt;
wire [15:0] ID_imm;

pipeline_ID ID_pipeline(.clk(clk),.reset(reset),.ID_PC(ID_PC),.ID_instruction(ID_instruction),.IRQ(irqout),
                 .PCSrc(PCSrc),.ID_rs(ID_rs),.ID_RegDst(ID_RegDst),.ID_RegWr(ID_RegWr),.ID_ALUSrc1(ALUSrc1),.ID_ALUSrc2(ALUSrc2),
                 .ID_ALUFun(ID_ALUFun),.ID_Sign(ID_Sign),.ID_MemWr(ID_MemWr),.ID_MemRd(ID_MemRd),.ID_MemToReg(ID_MemToReg),
                 .EXTOp(EXTOp),.LUOp(LUOp),.ConBA(ConBA),.JT(JT),.PCout(PCout),.ID_dataA(ID_dataA),.ID_dataB(ID_dataB),
                 .ALUout0(ALUOut0),.WB_RegWr(WB_RegWr),.ID_WrReg(ID_WrReg),.Branch(Branch),.IDcontrol_jal(IDcontrol_jal),
                 .WB_Destiny(WB_Destiny),.ID_rt(ID_rt),.ID_rd(ID_rd),.WB_out(WB_out),.Mem_in(Mem_in),
                 .ForwardC(ForwardC),.ForwardD(ForwardD),.IDcontrol_Jump(IDcontrol_Jump),.IDcontrol_Branch(IDcontrol_Branch),
                 .ID_shamt(ID_shamt),.ID_imm(ID_imm));
wire [4:0] EX_shamt;
wire [15:0] EX_imm;
wire EX_ALUSrc1, EX_ALUSrc2, EX_EXTOp, EX_LUOp;
wire [31:0] EX_dataA;
wire [31:0] EX_dataB;
IDEX_reg reg_IDEX(.clk(clk),.reset(reset),.stall(stall),.ID_MemWr(ID_MemWr),.EX_MemWr(EX_MemWr),
                .ID_RegWr(ID_RegWr),.EX_RegWr(EX_RegWr),.ID_MemRd(ID_MemRd),.EX_MemRd(EX_MemRd),
                .ID_ALUFun(ID_ALUFun),.EX_ALUFun(EX_ALUFun),.ID_shamt(ID_shamt),.ID_imm(ID_imm),
                .ID_RegDst(ID_RegDst),.EX_RegDst(EX_RegDst),.ID_dataA(ID_dataA),.ID_dataB(ID_dataB),
                .ID_MemtoReg(ID_MemToReg),.EX_MemtoReg(EX_MemtoReg),.ID_WrReg(ID_WrReg),.EX_WrReg(EX_WrReg),
                .ID_PC(ID_PC),.EX_PC(EX_PC),.ID_rt(ID_rt),.EX_rt(EX_rt),.ID_rd(ID_rd),.EX_rd(EX_rd),
                .ID_rs(ID_rs),.EX_rs(EX_rs),.IDcontrol_jal(IDcontrol_jal),.EXcontrol_jal(EXcontrol_jal),
                .ID_ALUSrc1(ALUSrc1),.ID_ALUSrc2(ALUSrc2),.ID_EXTOp(EXTOp),.ID_LUOp(LUOp),.ID_Sign(ID_Sign),
                .EX_shamt(EX_shamt),.EX_imm(EX_imm),.EX_dataA(EX_dataA),.EX_dataB(EX_dataB),.EX_Sign(EX_Sign),
                .EX_ALUSrc1(EX_ALUSrc1),.EX_ALUSrc2(EX_ALUSrc2),.EX_EXTOp(EX_EXTOp),.EX_LUOp(EX_LUOp));



pipeline_EX EX_pipeline(.ForwardA(ForwardA),.ForwardB(ForwardB),.EX_ALUFun(EX_ALUFun),
                       .Sign(EX_Sign),.EX_ALUOut(EX_ALUOut),.MEMWBdata(WB_out),
                       .EXMEMdata(Mem_in),.EX_ALUSrc1(EX_ALUSrc1),.EX_ALUSrc2(EX_ALUSrc2),
                       .EX_EXTOp(EX_EXTOp),.EX_LUOp(EX_LUOp),.EX_dataA(EX_dataA),.EX_dataB(EX_dataB),.EX_shamt(EX_shamt),.EX_imm(EX_imm));

EXMEM_reg reg_EXMEM(.clk(clk),.reset(reset),.EX_ALUout(EX_ALUOut),.Mem_in(Mem_in),.EXcontrol_jal(EXcontrol_jal),
                    .EX_MemWr(EX_MemWr),.Mem_MemWr(Mem_MemWr),.EX_MemRd(EX_MemRd),.Memcontrol_jal(Memcontrol_jal),
                    .Mem_MemRd(Mem_MemRd),.EX_BusB(EX_dataB),.Mem_BusB(Mem_BusB), //EX_dataB??$rt
                    .EX_RegWr(EX_RegWr),.Mem_RegWr(Mem_RegWr),.EX_MemtoReg(EX_MemtoReg),.Mem_MemtoReg(Mem_MemtoReg),
                    .EX_RegDst(EX_RegDst),.Mem_RegDst(Mem_RegDst),.EX_WrReg(EX_WrReg),.Mem_WrReg(Mem_WrReg),
                    .EX_PC(EX_PC),.Mem_PC(Mem_PC),.EX_rt(EX_rt),.Mem_rt(Mem_rt),.EX_rd(EX_rd),.Mem_rd(Mem_rd));

pipeline_MEM MEM_pipeline(.clk(clk),.reset(reset),.Mem_MemRd(Mem_MemRd),.Mem_MemWr(Mem_MemWr),
                          .Mem_in(Mem_in),.Mem_outA(Mem_outA),.Mem_outB(Mem_outB),.Mem_BusB(Mem_BusB),
                          .led(led),.switch(switch),.digi(digi),.irqout(irqout),.uart_rx(uart_rx),.uart_tx(uart_tx),
                          .Forwardsw(Forwardsw),.WB_dataB(WB_out));

MEMWB_reg reg_MEMWB(.clk(clk),.reset(reset),.Mem_outB(Mem_outB),.WB_inB(WB_inB),.Mem_outA(Mem_outA),
                    .WB_inA(WB_inA),.Mem_RegDst(Mem_RegDst),.WB_RegDst(WB_RegDst),.Mem_RegWr(Mem_RegWr),
                    .WB_RegWr(WB_RegWr),.Mem_WrReg(Mem_WrReg),.WB_WrReg(WB_WrReg),.Mem_rd(Mem_rd),.WB_rd(WB_rd),
                    .Mem_MemtoReg(Mem_MemtoReg),.WB_MemtoReg(WB_MemtoReg),.Mem_PC(Mem_PC),.WB_PC(WB_PC));

pipeline_WB WB_pipeline(.WB_RegDst(WB_RegDst),.WB_MemtoReg(WB_MemtoReg),.WB_out(WB_out),
                        .WB_inA(WB_inA),.WB_inB(WB_inB),.WB_PC(WB_PC),.WB_WrReg(WB_WrReg),.WB_Destiny(WB_Destiny));
endmodule
