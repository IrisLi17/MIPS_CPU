module Control(
input [31:0] Instruct, 
input IRQ,
input PC31,
output reg [2:0] PCSrc,
output reg [1:0] RegDst,
output reg RegWr,
output reg ALUSrc1,
output reg ALUSrc2,
output reg [5:0] ALUFun,
output reg Sign,
output reg MemWr,
output reg MemRd,
output reg [1:0] MemToReg,
output reg EXTOp,
output reg LUOp
);
	wire OpCode;
  wire Funct;
  assign OpCode = Instruct[31:26];
  assign Funct = Instruct[5:0];

always @(*) begin
if (~PC31) begin //user state
  if (IRQ) begin //interrupt
    RegWr <= 1;
    MemRd <= 0;
    MemWr <= 0;
    RegDst <= 2'b11;
    MemToReg <= 2'b10;
    PCSrc <= 3'b100;
  end
  else begin
    case (OpCode)
      6'b000000: begin //R-type
        case (Funct)
          6'b100000: begin //add
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b000000;
            Sign <= 1;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b100001: begin //addu
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b000000;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b100010: begin //sub
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b000001;
            Sign <= 1;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b100011: begin //subu
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b000001;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b100100: begin //and
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b011000;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b100101: begin //or
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b011110;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b100110: begin //xor
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b010110;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b100111: begin //nor
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b010001;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b000000: begin //sll
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 1; //shamt
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b100000;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b000010: begin //srl
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 1; //shamt
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b100001;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b000011: begin //sra
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 1; //shamt
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b100011;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b101010: begin //slt
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b110101;
            Sign <= 1;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
          end
          6'b001000: begin //jr
            PCSrc <= 3'b011; //reg
            RegWr <= 0;
            MemWr <= 0;
            MemRd <= 0;
          end
          6'b001001: begin //jalr
            PCSrc <= 3'b011; //reg
            RegWr <= 1;
            RegDst <= 2'b00; //rd
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b10; //PC+4
          end
          default: begin //exception
           RegWr <= 1;
           MemRd <= 0;
           MemWr <= 0;
           RegDst <= 2'b11;
           MemToReg <= 2'b10;
           PCSrc <= 3'b101;
          end
        endcase
      end
      6'b100011: begin //lw
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 1;
        MemToReg <= 2'b01; //mem
        EXTOp <= 1; //signed
        LUOp <= 0;
      end
      6'b101011: begin //sw
        PCSrc <= 3'b000; //PC+4
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 0;
        MemWr <= 1;
        MemRd <= 0;
        EXTOp <= 1; //signed
        LUOp <= 0;
      end
      6'b001111: begin //lui
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        LUOp <= 1;
      end
      6'b001000: begin //addi
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 1;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 1; //signed
        LUOp <= 0;
      end
      6'b001001: begin //addiu
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 1; //signed
        LUOp <= 0;
      end
      6'b001100: begin //andi
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b011000;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 0; //unsigned
        LUOp <= 0;
      end
      6'b001010: begin //slti
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b110101;
        Sign <= 1;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 1; //signed
        LUOp <= 0;
      end
      6'b001011: begin //sltiu
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b110101;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 1; //signed
        LUOp <= 0;
      end
      6'b000100: begin //beq
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b110011;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
      end
      6'b000101: begin //bne
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b110001;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
      end
      6'b000110: begin //blez
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b111101;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
      end
      6'b000111: begin //bgtz
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b111111;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
      end
      6'b000001: begin //bltz
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b111011;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
      end
      6'b000010: begin //j
        PCSrc <= 3'b010; //j
        RegWr <= 0;
        MemWr <= 0;
        MemRd <= 0;
      end
      6'b000011: begin //jal
        PCSrc <= 3'b010; //j
        RegWr <= 1;
        RegDst <= 2'b10; //ra
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b10; //PC+4
      end
      default: begin //exception
         RegWr <= 1;
         MemRd <= 0;
         MemWr <= 0;
         RegDst <= 2'b11;
         MemToReg <= 2'b10;
         PCSrc <= 3'b101;
      end
    endcase
  end
end

else begin //core state
  case (OpCode)
    6'b000000: begin //R-type
      case (Funct)
        6'b100000: begin //add
          PCSrc <= 3'b000; //PC+4
          RegDst <= 2'b00; //rd
          RegWr <= 1;
          ALUSrc1 <= 0; //Reg
          ALUSrc2 <= 0; //Reg
          ALUFun <= 6'b000000;
          Sign <= 1;
          MemWr <= 0;
          MemRd <= 0;
          MemToReg <= 2'b00; //ALU
        end
        6'b100001: begin //addu
          PCSrc <= 3'b000; //PC+4
          RegDst <= 2'b00; //rd
          RegWr <= 1;
          ALUSrc1 <= 0; //Reg
          ALUSrc2 <= 0; //Reg
          ALUFun <= 6'b000000;
          Sign <= 0;
          MemWr <= 0;
          MemRd <= 0;
          MemToReg <= 2'b00; //ALU
        end
        6'b100010: begin //sub
          PCSrc <= 3'b000; //PC+4
          RegDst <= 2'b00; //rd
          RegWr <= 1;
          ALUSrc1 <= 0; //Reg
          ALUSrc2 <= 0; //Reg
          ALUFun <= 6'b000001;
          Sign <= 1;
          MemWr <= 0;
          MemRd <= 0;
          MemToReg <= 2'b00; //ALU
        end
        6'b100011: begin //subu
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b000001;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b100100: begin //and
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b011000;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b100101: begin //or
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b011110;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b100110: begin //xor
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b010110;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b100111: begin //nor
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b010001;
            Sign <= 0;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b000000: begin //sll
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 1; //shamt
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b100000;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b000010: begin //srl
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 1; //shamt
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b100001;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b000011: begin //sra
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 1; //shamt
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b100011;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b101010: begin //slt
            PCSrc <= 3'b000; //PC+4
            RegDst <= 2'b00; //rd
            RegWr <= 1;
            ALUSrc1 <= 0; //Reg
            ALUSrc2 <= 0; //Reg
            ALUFun <= 6'b110101;
            Sign <= 1;
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b00; //ALU
        end
        6'b001000: begin //jr
            PCSrc <= 3'b011; //reg
            RegWr <= 0;
            MemWr <= 0;
            MemRd <= 0;
        end
        6'b001001: begin //jalr
            PCSrc <= 3'b011; //reg
            RegWr <= 1;
            RegDst <= 2'b00; //rd
            MemWr <= 0;
            MemRd <= 0;
            MemToReg <= 2'b10; //PC+4
        end
        default: begin end
      endcase
    end
    6'b100011: begin //lw
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 1;
        MemToReg <= 2'b01; //mem
        EXTOp <= 1; //signed
        LUOp <= 0;
    end
    6'b101011: begin //sw
        PCSrc <= 3'b000; //PC+4
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 0;
        MemWr <= 1;
        MemRd <= 0;
        EXTOp <= 1; //signed
        LUOp <= 0;
    end
    6'b001111: begin //lui
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        LUOp <= 1;
    end
    6'b001000: begin //addi
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 1;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 1; //signed
        LUOp <= 0;
    end
    6'b001001: begin //addiu
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b000000;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 1; //signed
        LUOp <= 0;
    end
    6'b001100: begin //andi
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b011000;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 0; //unsigned
        LUOp <= 0;
    end
    6'b001010: begin //slti
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b110101;
        Sign <= 1;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 1; //signed
        LUOp <= 0;
    end
    6'b001011: begin //sltiu
        PCSrc <= 3'b000; //PC+4
        RegDst <= 2'b01; //rt
        RegWr <= 1;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 1; //imm
        ALUFun <= 6'b110101;
        Sign <= 0;
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b00; //ALU
        EXTOp <= 1; //signed
        LUOp <= 0;
    end
    6'b000100: begin //beq
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b110011;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
    end
    6'b000101: begin //bne
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b110001;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
    end
    6'b000110: begin //blez
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b111101;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
    end
    6'b000111: begin //bgtz
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b111111;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
    end
    6'b000001: begin //bltz
        PCSrc <= 3'b001; //beq
        RegWr <= 0;
        ALUSrc1 <= 0; //Reg
        ALUSrc2 <= 0; //Reg
        ALUFun <= 6'b111011;
        MemWr <= 0;
        MemRd <= 0;
        EXTOp <= 1; //signed
    end
    6'b000010: begin //j
        PCSrc <= 3'b010; //j
        RegWr <= 0;
        MemWr <= 0;
        MemRd <= 0;
    end
    6'b000011: begin //jal
        PCSrc <= 3'b010; //j
        RegWr <= 1;
        RegDst <= 2'b10; //ra
        MemWr <= 0;
        MemRd <= 0;
        MemToReg <= 2'b10; //PC+4
    end
    default: begin end
  endcase
end
end

endmodule