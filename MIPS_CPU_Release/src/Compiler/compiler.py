import re


def reg2code(register):
    """input s0,s1... or 1,2,3...,output 5-bit code as a str"""
    register = str(register).lower()
    digit = None
    if register.isdigit():
        digit = int(register)
    else:
        if register == "zero":
            digit = 0
        elif register == "at":
            digit = 1
        elif register == "v0":
            digit = 2
        elif register == "v1":
            digit = 3
        elif register[0] == 'a':
            digit = 4 + int(register[1])
        elif register[0] == 't' and int(register[1]) < 8:
            digit = 8 + int(register[1])
        elif register[0] == 't' and int(register[1]) >= 8:
            digit = 24 + int(register[1])
        elif register[0] == 's' and register[1].isdigit():
            digit = 16 + int(register[1])
        elif register[0] == 'k':
            digit = 26 + int(register[1])
        elif register == "gp":
            digit = 28
        elif register == "sp":
            digit = 29
        elif register == "fp":
            digit = 30
        elif register == "ra":
            digit = 31
    return '{:05b}'.format(digit)


def immExt(stringInt, bitNumber = 16):
    """整数转16位二进制，正数用原码，负数用补码"""
    if len(stringInt)>2 and stringInt[0:2] == '0x':
        interger = int(stringInt,base=16)
    else:
        interger = int(stringInt)
    if  interger >= 0:
        return ('{:0' + str(bitNumber) + 'b}').format(interger)
    else:
        return ('{:0' + str(bitNumber) + 'b}').format(2**16 + interger)[-bitNumber:]


def assem2code(fields, curIndex = None, tagDict = None, startoffset = 0):
    assert len(fields)
    instruc = fields[0].lower()
    if instruc == "add":
        assert len(fields)==4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        shamt = "00000"
        funct = "100000"
        return opcode + rs + rt + rd + shamt + funct
    if instruc == "addi":
        assert len(fields) == 4
        opcode = "001000"
        rt = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        imm = immExt(fields[3])
        return opcode + rs + rt + imm
    if instruc == "addiu":
        assert len(fields) == 4
        opcode = "001001"
        rt = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        imm = immExt(fields[3])
        return opcode + rs + rt + imm
    if instruc == "addu":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        shamt = "00000"
        funct = "100001"
        return opcode + rs + rt + rd + shamt + funct
    if instruc == "and":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        shamt = "00000"
        funct = "100100"
        return opcode + rs + rt + rd + shamt + funct
    if instruc == "andi":
        assert len(fields) == 4
        opcode = "001100"
        rt = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        imm = immExt(fields[3])
        return opcode + rs + rt + imm
    if instruc == "beq":
        assert len(fields) == 4
        opcode = "000100"
        rs = reg2code(fields[1][1:])
        rt = reg2code(fields[2][1:])
        offset = immExt(str(tagDict[fields[3]] - curIndex - 1))
        return opcode + rs + rt + offset
    if instruc == "bgtz":
        assert len(fields) == 3
        opcode = "000111"
        rs = reg2code(fields[1][1:])
        offset = immExt(str(tagDict[fields[2]] - curIndex - 1))
        return opcode + rs + "00000" + offset
    if instruc == "blez":
        assert len(fields) == 3
        opcode = "000110"
        rs = reg2code(fields[1][1:])
        offset = immExt(str(tagDict[fields[2]] - curIndex - 1))
        return opcode + rs + "00000" + offset
    if instruc == "bltz":
        assert len(fields) == 3
        opcode = "000001"
        rs = reg2code(fields[1][1:])
        offset = immExt(str(tagDict[fields[2]] - curIndex - 1))
        return opcode + rs + "00000" + offset
    if instruc == "bne":
        assert len(fields) == 4
        opcode = "000101"
        rs = reg2code(fields[1][1:])
        rt = reg2code(fields[2][1:])
        offset = immExt(str(tagDict[fields[3]] - curIndex - 1))
        return opcode + rs + rt + offset
    if instruc == "j":
        assert len(fields) == 2
        opcode = "000010"
        target = immExt(str(tagDict[fields[1]] + startoffset), 26)
        return opcode + target
    if instruc == "jal":
        assert len(fields) == 2
        opcode = "000011"
        target = immExt(str(tagDict[fields[1]] + startoffset), 26)
        return opcode + target
    if instruc == "jalr":
        # jalr rs
        # jalr rd, rs
        if len(fields) == 2:
            opcode = "000000"
            rs = reg2code(fields[1][1:])
            rd = reg2code("31")
            funct = "001001"
        elif len(fields) == 3:
            opcode = "000000"
            rd = reg2code(fields[1][1:])
            rs = reg2code(fields[2][1:])
            funct = "001001"
        return opcode + rs + "00000" + rd + "00000" + funct
    if instruc == "jr":
        assert len(fields) == 2
        opcode = "000000"
        rs = reg2code(fields[1][1:])
        funct = "001000"
        return opcode + rs + "0000000000" + "00000" + funct
    if instruc == "lui":
        assert len(fields) == 3
        opcode = "001111"
        rt = reg2code(fields[1][1:])
        imm = immExt(fields[2])
        return opcode + "00000" + rt + imm
    if instruc == "lw":
        assert len(fields) == 3
        pattern1 = re.compile('\((.+)\)')
        basestr = re.findall(pattern1,fields[2])[0]
        pattern2 = re.compile('([0-9]+)\(')
        offsetstr = re.findall(pattern2,fields[2])[0]
        rt = reg2code(fields[1][1:])
        base = reg2code(basestr[1:])
        offset = immExt(offsetstr)
        opcode = "100011"
        return opcode + base + rt + offset
    if instruc == "nop":
        return "000000" + "00000" + "00000" + "00000" + "00000" + "000000"
    if instruc == "nor":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        shamt = "00000"
        funct = "100111"
        return opcode + rs + rt + rd + shamt + funct
    if instruc == "or":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        shamt = "00000"
        funct = "100101"
        return opcode + rs + rt + rd + shamt + funct
    if instruc == "ori":
        assert len(fields) == 4
        opcode = "001101"
        rt = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        imm = immExt(fields[3])
        return opcode + rs + rt + imm
    if instruc == "sll":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rt = reg2code(fields[2][1:])
        shamt = immExt(fields[3], 5)
        return opcode + "00000" + rt + rd + shamt + "000000"
    if instruc == "slt":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        funct = "101010"
        return opcode + rs + rt + rd + "00000" + funct
    if instruc == "slti":
        assert len(fields) == 4
        opcode = "001010"
        rt = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        imm = immExt(fields[3])
        return opcode + rs + rt + imm
    if instruc == "sltiu":
        assert len(fields) == 4
        opcode = "001011"
        rt = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        imm = immExt(fields[3])
        return opcode + rs + rt + imm
    if instruc == "sra":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rt = reg2code(fields[2][1:])
        shamt = immExt(fields[3],5)
        funct = "000011"
        return opcode + "00000" + rt + rd + shamt + funct
    if instruc == "srl":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rt = reg2code(fields[2][1:])
        shamt = immExt(fields[3], 5)
        return opcode + "00000" + rt + rd + shamt + "000010"
    if instruc == "sub":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        shamt = "00000"
        funct = "100010"
        return opcode + rs + rt + rd + shamt + funct
    if instruc == "subu":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        shamt = "00000"
        funct = "100011"
        return opcode + rs + rt + rd + shamt + funct
    if instruc == "sw":
        assert len(fields) == 3
        pattern1 = re.compile('\((.+)\)')
        basestr = re.findall(pattern1, fields[2])[0]
        pattern2 = re.compile('([0-9]+)\(')
        offsetstr = re.findall(pattern2, fields[2])[0]
        rt = reg2code(fields[1][1:])
        base = reg2code(basestr[1:])
        offset = immExt(offsetstr)
        opcode = "101011"
        return opcode + base + rt + offset
    if instruc == "xor":
        assert len(fields) == 4
        opcode = "000000"
        rd = reg2code(fields[1][1:])
        rs = reg2code(fields[2][1:])
        rt = reg2code(fields[3][1:])
        shamt = "00000"
        funct = "100110"
        return opcode + rs + rt + rd + shamt + funct
    else:
        print("invalid instruction!")
        return "000000" + "00000" + "00000" + "00000" + "00000" + "000000"

def translateFile (assembleFile, outName):
    with open(assembleFile,encoding='utf8') as f:
        lines = f.readlines()
        codes = []   # 结构为[[tag,fields],[tag,fields],...]
        binCodes = []
        tagDict = {}
        for line in lines:
            line = line.strip()  #去除首尾空白字符
            tag = ''
            fields = []
            if '#' in line:
                index_f = line.find('#')
                line = line[0:index_f]  #去除注释
            if not len(line):   # 去掉空行
                continue
            if ':' in line:  #提取tag
                tag_pattern = '^[a-zA-Z0-9]+'
                tag = re.findall(tag_pattern, line)[0]
                line = line[line.find(':') + 1:]
            if len(line):  #提取汇编指令
                temp = line.split()  #空白字符分割
                for item in temp:
                    fields += item.split(',')  #逗号分割
                fields = [field for field in fields if field]  #去除空白
            # 整合tag,因为tag可能自己占了一行
            if len(codes) and len(codes[-1][0]) and codes[-1][1] == [] and len(tag) == 0 and len(fields):
                codes[-1][1] = fields
            else:
                codes.append([tag,fields])
                if tag:
                    tagDict[tag] = len(codes) - 1 #插入tag-行号键值对，行号从0开始
    f.close()
    startoffset = 96
    for lineNumber in range(len(codes)):
        item = codes[lineNumber]
        assert len(item[1])
        #用到tag的指令翻译？
        instruc = item[1][0].lower()
        if instruc == "beq" or instruc == "bgtz" or instruc == "blez" or instruc == "bltz" or instruc == "bne" \
                or instruc == "j" or instruc == "jal" :  #补充所有用到tag的指令
            binCodes.append(assem2code(item[1], lineNumber, tagDict, startoffset))
        else:
            binCodes.append(assem2code(item[1]))
    #output
    # with open(outName,'w') as fout:
    #     for item in binCodes:
    #         fout.write(item + '\n')
    # fout.close()
    with open(outName,'w') as fout:
        for index in range(len(binCodes)):
            fout.write(str(startoffset + index)+": Instruction <= "+"32\'b"+str(binCodes[index])+ str("; // ") + str(codes[index]) + "\n")
    fout.close()

translateFile("InterruptionCode.asm","rom_instructions.v")