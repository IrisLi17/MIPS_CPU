17: Instruction <= 32'b00111100000011010100000000000000; // ['', ['lui', '$t5', '0x4000']]
18: Instruction <= 32'b10101101101000000000000000001000; // ['', ['sw', '$zero', '8($t5)']]
19: Instruction <= 32'b00111100000011001111111111111111; // ['', ['lui', '$t4', '0xffff']]
20: Instruction <= 32'b00100000000011001100000000000000; // ['', ['addi', '$t4', '$zero', '0xc000']]
21: Instruction <= 32'b10101101101011000000000000000000; // ['', ['sw', '$t4', '0($t5)']]
22: Instruction <= 32'b00000000000000000111000000100111; // ['', ['nor', '$t6', '$zero', '$zero']]
23: Instruction <= 32'b10101101101011100000000000000100; // ['', ['sw', '$t6', '4($t5)']]
24: Instruction <= 32'b00100000000011000000000000000011; // ['', ['addi', '$t4', '$zero', '0x0003']]
25: Instruction <= 32'b10101101101011000000000000001000; // ['', ['sw', '$t4', '8($t5)']]
26: Instruction <= 32'b00000000000101010100000000101010; // ['loop', ['slt', '$t0', '$zero', '$s5']]
27: Instruction <= 32'b00000000000101100100100000101010; // ['', ['slt', '$t1', '$zero', '$s6']]
28: Instruction <= 32'b00000001000010010101000000100100; // ['', ['and', '$t2', '$t0', '$t1']]
29: Instruction <= 32'b00010101010000000000000000000010; // ['', ['bne', '$t2', '$zero', 'target']]
30: Instruction <= 32'b00000010101000001001000000100000; // ['', ['add', '$s2', '$s5', '$zero']]
31: Instruction <= 32'b00001000000000000000000000011010; // ['', ['j', 'loop']]
32: Instruction <= 32'b00000010110000001001100000100000; // ['target', ['add', '$s3', '$s6', '$zero']]
33: Instruction <= 32'b00000010010100110101100000101010; // ['compare', ['slt', '$t3', '$s2', '$s3']]
34: Instruction <= 32'b00010001011000000000000000000011; // ['', ['beq', '$t3', '$zero', 's2greater']]
35: Instruction <= 32'b00000010010000000110000000100000; // ['', ['add', '$t4', '$s2', '$zero']]
36: Instruction <= 32'b00000010011000001001000000100000; // ['', ['add', '$s2', '$s3', '$zero']]
37: Instruction <= 32'b00000001100000001001100000100000; // ['', ['add', '$s3', '$t4', '$zero']]
38: Instruction <= 32'b00000010010100111010000000100010; // ['s2greater', ['sub', '$s4', '$s2', '$s3']]
39: Instruction <= 32'b00010010100000000000000000000100; // ['', ['beq', '$s4', '$zero', 'finish']]
40: Instruction <= 32'b00000000000000000000000000000000; // ['', ['sll', '$zero', '$zero', '0']]
41: Instruction <= 32'b00000010011000001001000000100000; // ['', ['add', '$s2', '$s3', '$zero']]
42: Instruction <= 32'b00000010100000001001100000100000; // ['', ['add', '$s3', '$s4', '$zero']]
43: Instruction <= 32'b00001000000000000000000000100001; // ['', ['j', 'compare']]
44: Instruction <= 32'b00111100000011010100000000000000; // ['finish', ['lui', '$t5', '0x4000']]
45: Instruction <= 32'b10101101101100110000000000011000; // ['', ['sw', '$s3', '24($t5)']]
46: Instruction <= 32'b10101101101100110000000000001100; // ['', ['sw', '$s3', '12($t5)']]
47: Instruction <= 32'b00000000000000001010100000100000; // ['', ['add', '$s5', '$zero', '$zero']]
48: Instruction <= 32'b00000000000000001011000000100000; // ['', ['add', '$s6', '$zero', '$zero']]
49: Instruction <= 32'b00001000000000000000000000110010; // ['', ['j', 'Exit']]
50: Instruction <= 32'b00111100000010000100000000000000; // ['Exit', ['lui', '$t0', '0x4000']]
51: Instruction <= 32'b10001101000010010000000000100000; // ['', ['lw', '$t1', '32($t0)']]
52: Instruction <= 32'b00100000000010100000000000001000; // ['', ['addi', '$t2', '$zero', '8']]
53: Instruction <= 32'b00000001001010100100100000100100; // ['', ['and', '$t1', '$t1', '$t2']]
54: Instruction <= 32'b00010101001000001111111111100011; // ['', ['bne', '$t1', '$zero', 'loop']]
55: Instruction <= 32'b00001000000000000000000000110010; // ['', ['j', 'Exit']]
