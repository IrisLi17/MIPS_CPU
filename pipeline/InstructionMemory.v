
module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
	    case (Address[9:2])
			0: Instruction <= 32'h20080001;
			1: Instruction <= 32'h200a0001;
			2: Instruction <= 32'h2018000d;
			3: Instruction <= 32'h20190028;
			4: Instruction <= 32'h1100000a;
			5: Instruction <= 32'h0338482a;
			6: Instruction <= 32'h11200004;
			7: Instruction <= 32'h03194022;
			8: Instruction <= 32'h1900fffb;
			9: Instruction <= 32'h0008c020;
			10: Instruction <= 32'h08100007;
			11: Instruction <= 32'h03384022;
			12: Instruction <= 32'h1900fff7;
			13: Instruction <= 32'h0008c820;
			14: Instruction <= 32'h0810000b;
			15: Instruction <= 32'h03191025;
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
