module CPU(reset, sys_clk, led, switch, digi, uart_rx, uart_tx);
	input reset, sys_clk;
	output [7:0] led;
	input [7:0] switch;
	output [11:0] digi;
	input uart_rx;
	output uart_tx;

	wire clk;
	cpu_clk cpu_clk(.sys_clk(sys_clk),.clk(clk));
	
	reg [31:0] PC;
	wire [31:0] PC_next;
	always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h80000000;
		else
			PC <= PC_next;
	
	wire [31:0] PC_plus_4;
	assign PC_plus_4 = PC + 32'd4;
	
	wire [31:0] Instruction;
	wire [31:0] InstructionMemIn;
	assign InstructionMemIn = {1'b0, PC[30:0]}; 
	InstructionMemory instruction_memory1(.Address(InstructionMemIn), .Instruction(Instruction));
	
	wire [1:0] RegDst;
	wire [2:0] PCSrc;
	wire MemRd;
	wire [1:0] MemtoReg;
	wire [5:0] ALUFun;
	wire Sign;
	wire EXTOp;
	wire LUOp;
	wire MemWr;
	wire ALUSrc1;
	wire ALUSrc2;
	wire RegWr;
	wire IRQ;
	
	Control control1(
		.Instruct(Instruction), .IRQ(IRQ), .PC31(PC[31]), .PCSrc(PCSrc),
		.RegDst(RegDst),.RegWr(RegWr),.ALUSrc1(ALUSrc1),.ALUSrc2(ALUSrc2),
		.ALUFun(ALUFun),.Sign(Sign),.MemWr(MemWr),.MemRd(MemRd),
		.MemToReg(MemtoReg),.EXTOp(EXTOp),.LUOp(LUOp)
	);
		
	wire [31:0] Databus1, Databus2, Databus3;
	wire [4:0] Write_register;
	assign Write_register = (RegDst == 2'b00)? Instruction[15:11]: (RegDst == 2'b01)? Instruction[20:16]: (RegDst == 2'b10)? 5'd31: 5'd26;	
	RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(RegWr), 
		.Read_register1(Instruction[25:21]), .Read_register2(Instruction[20:16]), .Write_register(Write_register),
		.Write_data(Databus3), .Read_data1(Databus1), .Read_data2(Databus2));
	
	wire [31:0] Ext_out;
	assign Ext_out = {EXTOp? {16{Instruction[15]}}: 16'h0000, Instruction[15:0]};
	
	wire [31:0] LU_out;
	assign LU_out = LUOp? {Instruction[15:0], 16'h0000}: Ext_out;
	
	wire [31:0] A;
	wire [31:0] B;
	wire [31:0] Z;
	assign A = ALUSrc1 ? {27'b0, Instruction[10:6]}: Databus1;
	assign B = ALUSrc2 ? LU_out: Databus2;
	ALU alu1(.A(A), .B(B), .S(Z), .Sign(Sign), .ALUFun(ALUFun));
	
	wire [31:0] Read_data;
	wire [31:0] Mem_Read_data;
	wire [31:0] Per_Read_data;
	wire [31:0] Uart_Read_data;
	DataMemory data_memory1(.reset(reset), .clk(clk), .Address(Z), .Write_data(Databus2), .Read_data(Mem_Read_data), .MemRead(MemRd), .MemWrite(MemWr));
	Peripheral myPeripheral(.reset(reset), .clk(clk), .rd(MemRd), .wr(MemWr), .addr(Z), .wdata(Databus2), 
	                        .rdata(Per_Read_data), .irqout(IRQ), .led(led), .switch(switch), 
							.digi(digi));
	UART myuart(.sys_clk(sys_clk),.cpu_clk(clk),.reset(reset),
		        .rd(MemRd),.wr(MemWr),.addr(Z),
				.rdata(Uart_Read_data),.wdata(Databus2),
				.uart_rx(uart_rx),.uart_tx(uart_tx));
	assign Read_data = Mem_Read_data | Per_Read_data | Uart_Read_data;
	assign Databus3 = (MemtoReg == 2'b00)? Z : (MemtoReg == 2'b01)? Read_data: PC_plus_4;
	
	wire [31:0] Jump_target;
	assign Jump_target = {1'b0,PC_plus_4[30:28], Instruction[25:0], 2'b00};
	
	wire [31:0] Branch_target;
	assign Branch_target = (Z[0])? PC_plus_4 + {LU_out[29:0], 2'b00}: PC_plus_4;
	parameter ILLOP = 32'h80000004;
	parameter XADR = 32'h80000008;
	assign PC_next = (PCSrc == 3'b000)? PC_plus_4: 
	                 ((PCSrc == 3'b001)? Branch_target: 
					 ((PCSrc == 3'b010)? Jump_target: 
					 ((PCSrc == 3'b011)? Databus1: 
					 ((PCSrc == 3'b100)? ILLOP: XADR))));

endmodule
	