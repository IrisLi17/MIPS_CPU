
module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
	    if (Address[31]) begin
		case (Address[15:2])
			/*// addi $a0, $zero, 12345 #(0x3039)
			8'd0:    Instruction <= {6'h08, 5'd0 , 5'd4 , 16'h3039};
			// addiu $a1, $zero, -11215 #(0xd431)
			8'd1:    Instruction <= {6'h09, 5'd0 , 5'd5 , 16'hd431};
			// sll $a2, $a1, 16
			8'd2:    Instruction <= {6'h00, 5'd0 , 5'd5 , 5'd6 , 5'd16 , 6'h00};
			// sra $a3, $a2, 16
			8'd3:    Instruction <= {6'h00, 5'd0 , 5'd6 , 5'd7 , 5'd16 , 6'h03};
			// beq $a3, $a1, L1
			8'd4:    Instruction <= {6'h04, 5'd7 , 5'd5 , 16'h0001};
			// lui $a0, -11111 #(0xd499)
			8'd5:    Instruction <= {6'h0f, 5'd0 , 5'd4 , 16'hd499};
			// L1:
			// add $t0, $a2, $a0
			8'd6:    Instruction <= {6'h00, 5'd6 , 5'd4 , 5'd8 , 5'd0 , 6'h20};
			// sra $t1, $t0, 8
			8'd7:    Instruction <= {6'h00, 5'd0 , 5'd8 , 5'd9 , 5'd8 , 6'h03};
			// addi $t2, $zero, -12345 #(0xcfc7)
			8'd8:    Instruction <= {6'h08, 5'd0 , 5'd10, 16'hcfc7};
			// slt $v0, $a0, $t2
			8'd9:    Instruction <= {6'h00, 5'd4 , 5'd10 , 5'd2 , 5'd0 , 6'h2a};
			// sltu $v1, $a0, $t2
			8'd10:   Instruction <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'h2b};
			// Loop:
			// j Loop
			8'd11:   Instruction <= {6'h02, 26'd11};*/
			
			14'd0: Instruction<= 32'b00111100000010000100000000000000;
			14'd1: Instruction<= 32'b10001101000010010000000000100000;
			14'd2: Instruction<= 32'b00000000000000000000000000000000;
			14'd3: Instruction<= 32'b00110001001010100000000000001000;
			14'd4: Instruction<= 32'b00010001010000000000000000001000;
			14'd5: Instruction<= 32'b00000000000000000000000000000000;
			14'd6: Instruction<= 32'b00010010000000000000000000000101;
			14'd7: Instruction<= 32'b00000000000000000000000000000000;
			14'd8: Instruction<= 32'b10001101000100010000000000011100;
			14'd9: Instruction<= 32'b00001000000000000000000000001100;
			14'd10: Instruction <= 32'b00000000000000000000000000000000;
			14'd11: Instruction <= 32'b10001101000100000000000000011100;
			14'd12: Instruction <= 32'b10001101000010010000000000010100;
			14'd13: Instruction <= 32'b00000000000100010110000100000010;
			14'd14: Instruction <= 32'b00110001001010100000000100000000;
			14'd15: Instruction <= 32'b00010001010000000000000000000101;
			14'd16: Instruction <= 32'b00000000000000000000000000000000;
			14'd17: Instruction <= 32'b00100000000010110000001000000000;
			14'd18: Instruction <= 32'b00001000000000000000000000100100;
			14'd19: Instruction <= 32'b00000000000000000000000000000000;
			14'd20: Instruction <= 32'b00110001001010100000001000000000;
			14'd21: Instruction <= 32'b00010001010000000000000000000110;
			14'd22: Instruction <= 32'b00000000000000000000000000000000;
			14'd23: Instruction <= 32'b00100000000010110000010000000000;
			14'd24: Instruction <= 32'b00110010000011000000000000001111;
			14'd25: Instruction <= 32'b00001000000000000000000000100100;
			14'd26: Instruction <= 32'b00000000000000000000000000000000;
			14'd27: Instruction <= 32'b00110001001010100000010000000000;
			14'd28: Instruction <= 32'b00010001010010010000000000000110;
			14'd29: Instruction <= 32'b00000000000000000000000000000000;
			14'd30: Instruction <= 32'b00100000000010110000100000000000;
			14'd31: Instruction <= 32'b00000000000100000110000100000010;
			14'd32: Instruction <= 32'b00001000000000000000000000100100;
			14'd33: Instruction <= 32'b00000000000000000000000000000000;
			14'd34: Instruction <= 32'b00100000000010110000000100000000;
			14'd35: Instruction <= 32'b00110010001011000000000000001111;
			14'd36: Instruction <= 32'b10001101100011010000000000000000;
			14'd37: Instruction <= 32'b00000000000000000000000000000000;
			14'd38: Instruction <= 32'b00000001101010110111000000100000;
			14'd39: Instruction <= 32'b10101101000011100000000000010100;
			14'd40: Instruction <= 32'b00000011010000000000000000001000;
			default: Instruction <= 32'h00000000;
		endcase
		end
		else begin
		  case(Address[15:2])
		  	default: Instruction <= 32'b0;
		  endcase
		end
		
endmodule
