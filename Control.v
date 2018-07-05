module Control(
input [31:0] Instruct, 
input IRQ,
input PC31,
output [2:0] PCSrc,
output [1:0] RegDst,
output RegWr,
output ALUSrc1,
output ALUSrc2,
output [5:0] ALUFun,
output Sign,
output MemWr,
output MemRd,
output [1:0] MemToReg,
output EXTOp,
output LUOp
);
	wire OpCode;
  wire Funct;
  assign OpCode = Instruct[31:26];
  assign Funct = Instruct[5:0];

if (!PC31) begin //user state
  if (IRQ) begin //interrupt
    assign RegWr = 1;
    assign MemRd = 0;
    assign MemWr = 0;
    assign RegDst = 2'b11;
    assign MemToReg = 2'b10;
    assign PCSrc = 3'b100;
  end
  else begin
    case (OpCode)
      6'b000000: begin //R-type
        case (Funct)
          6'b100000: begin //add
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b000000;
            assign Sign = 1;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b100001: begin //addu
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b000000;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b100010: begin //sub
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b000001;
            assign Sign = 1;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b100011: begin //subu
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b000001;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b100100: begin //and
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b011000;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b100101: begin //or
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b011110;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b100110: begin //xor
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b010110;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b100111: begin //nor
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b010001;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b000000: begin //sll
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 1; //shamt
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b100000;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b000010: begin //srl
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 1; //shamt
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b100001;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b000011: begin //sra
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 1; //shamt
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b100011;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b101010: begin //slt
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b110101;
            assign Sign = 1;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
          end
          6'b001000: begin //jr
            assign PCSrc = 3'b011; //reg
            assign RegWr = 0;
            assign MemWr = 0;
            assign MemRd = 0;
          end
          6'b001001: begin //jalr
            assign PCSrc = 3'b011; //reg
            assign RegWr = 1;
            assign RegDst = 2'b00; //rd
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b10; //PC+4
          end
          default: begin //exception
           assign RegWr = 1;
           assign MemRd = 0;
           assign MemWr = 0;
           assign RegDst = 2'b11;
           assign MemToReg = 2'b10;
           assign PCSrc = 3'b101;
          end
        endcase
      end
      6'b100011: begin //lw
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 1;
        assign MemToReg = 2'b01; //mem
        assign EXTOp = 1; //signed
        assign LUOp = 0;
      end
      6'b101011: begin //sw
        assign PCSrc = 3'b000; //PC+4
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 0;
        assign MemWr = 1;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
        assign LUOp = 0;
      end
      6'b001111: begin //lui
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign LUOp = 1;
      end
      6'b001000: begin //addi
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 1;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 1; //signed
        assign LUOp = 0;
      end
      6'b001001: begin //addiu
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 1; //signed
        assign LUOp = 0;
      end
      6'b001100: begin //andi
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b011000;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 0; //unsigned
        assign LUOp = 0;
      end
      6'b001010: begin //slti
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b110101;
        assign Sign = 1;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 1; //signed
        assign LUOp = 0;
      end
      6'b001011: begin //sltiu
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b110101;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 1; //signed
        assign LUOp = 0;
      end
      6'b000100: begin //beq
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b110011;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
      end
      6'b000101: begin //bne
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b110001;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
      end
      6'b000110: begin //blez
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b111101;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
      end
      6'b000111: begin //bgtz
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b111111;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
      end
      6'b000001: begin //bltz
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b111011;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
      end
      6'b000010: begin //j
        assign PCSrc = 3'b010; //j
        assign RegWr = 0;
        assign MemWr = 0;
        assign MemRd = 0;
      end
      6'b000011: begin //jal
        assign PCSrc = 3'b010; //j
        assign RegWr = 1;
        assign RegDst = 2'b10; //ra
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b10; //PC+4
      end
      default: begin //exception
         assign RegWr = 1;
         assign MemRd = 0;
         assign MemWr = 0;
         assign RegDst = 2'b11;
         assign MemToReg = 2'b10;
         assign PCSrc = 3'b101;
      end
    endcase
  end
end

else begin //core state
  case (OpCode)
    6'b000000: begin //R-type
      case (Funct)
        6'b100000: begin //add
          assign PCSrc = 3'b000; //PC+4
          assign RegDst = 2'b00; //rd
          assign RegWr = 1;
          assign ALUSrc1 = 0; //Reg
          assign ALUSrc2 = 0; //Reg
          assign ALUFun = 6'b000000;
          assign Sign = 1;
          assign MemWr = 0;
          assign MemRd = 0;
          assign MemToReg = 2'b00; //ALU
        end
        6'b100001: begin //addu
          assign PCSrc = 3'b000; //PC+4
          assign RegDst = 2'b00; //rd
          assign RegWr = 1;
          assign ALUSrc1 = 0; //Reg
          assign ALUSrc2 = 0; //Reg
          assign ALUFun = 6'b000000;
          assign Sign = 0;
          assign MemWr = 0;
          assign MemRd = 0;
          assign MemToReg = 2'b00; //ALU
        end
        6'b100010: begin //sub
          assign PCSrc = 3'b000; //PC+4
          assign RegDst = 2'b00; //rd
          assign RegWr = 1;
          assign ALUSrc1 = 0; //Reg
          assign ALUSrc2 = 0; //Reg
          assign ALUFun = 6'b000001;
          assign Sign = 1;
          assign MemWr = 0;
          assign MemRd = 0;
          assign MemToReg = 2'b00; //ALU
        end
        6'b100011: begin //subu
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b000001;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b100100: begin //and
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b011000;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b100101: begin //or
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b011110;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b100110: begin //xor
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b010110;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b100111: begin //nor
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b010001;
            assign Sign = 0;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b000000: begin //sll
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 1; //shamt
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b100000;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b000010: begin //srl
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 1; //shamt
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b100001;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b000011: begin //sra
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 1; //shamt
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b100011;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b101010: begin //slt
            assign PCSrc = 3'b000; //PC+4
            assign RegDst = 2'b00; //rd
            assign RegWr = 1;
            assign ALUSrc1 = 0; //Reg
            assign ALUSrc2 = 0; //Reg
            assign ALUFun = 6'b110101;
            assign Sign = 1;
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b00; //ALU
        end
        6'b001000: begin //jr
            assign PCSrc = 3'b011; //reg
            assign RegWr = 0;
            assign MemWr = 0;
            assign MemRd = 0;
        end
        6'b001001: begin //jalr
            assign PCSrc = 3'b011; //reg
            assign RegWr = 1;
            assign RegDst = 2'b00; //rd
            assign MemWr = 0;
            assign MemRd = 0;
            assign MemToReg = 2'b10; //PC+4
        end
        default: begin end
      endcase
    end
    6'b100011: begin //lw
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 1;
        assign MemToReg = 2'b01; //mem
        assign EXTOp = 1; //signed
        assign LUOp = 0;
    end
    6'b101011: begin //sw
        assign PCSrc = 3'b000; //PC+4
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 0;
        assign MemWr = 1;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
        assign LUOp = 0;
    end
    6'b001111: begin //lui
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign LUOp = 1;
    end
    6'b001000: begin //addi
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 1;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 1; //signed
        assign LUOp = 0;
    end
    6'b001001: begin //addiu
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b000000;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 1; //signed
        assign LUOp = 0;
    end
    6'b001100: begin //andi
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b011000;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 0; //unsigned
        assign LUOp = 0;
    end
    6'b001010: begin //slti
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b110101;
        assign Sign = 1;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 1; //signed
        assign LUOp = 0;
    end
    6'b001011: begin //sltiu
        assign PCSrc = 3'b000; //PC+4
        assign RegDst = 2'b01; //rt
        assign RegWr = 1;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 1; //imm
        assign ALUFun = 6'b110101;
        assign Sign = 0;
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b00; //ALU
        assign EXTOp = 1; //signed
        assign LUOp = 0;
    end
    6'b000100: begin //beq
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b110011;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
    end
    6'b000101: begin //bne
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b110001;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
    end
    6'b000110: begin //blez
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b111101;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
    end
    6'b000111: begin //bgtz
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b111111;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
    end
    6'b000001: begin //bltz
        assign PCSrc = 3'b001; //beq
        assign RegWr = 0;
        assign ALUSrc1 = 0; //Reg
        assign ALUSrc2 = 0; //Reg
        assign ALUFun = 6'b111011;
        assign MemWr = 0;
        assign MemRd = 0;
        assign EXTOp = 1; //signed
    end
    6'b000010: begin //j
        assign PCSrc = 3'b010; //j
        assign RegWr = 0;
        assign MemWr = 0;
        assign MemRd = 0;
    end
    6'b000011: begin //jal
        assign PCSrc = 3'b010; //j
        assign RegWr = 1;
        assign RegDst = 2'b10; //ra
        assign MemWr = 0;
        assign MemRd = 0;
        assign MemToReg = 2'b10; //PC+4
    end
    default: begin end
  endcase
end

endmodule