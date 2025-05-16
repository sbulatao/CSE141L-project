import re

class Assembler:
    def __init__(self):
        self.registers = {  # general purpose registers
            "r0": "000",
            "r1": "001",
            "r2": "010",
            "r3": "011",
            "r4": "100",
            "r5": "101",
            "r6": "110",
            "r7": "111",
        }
 
    def encode(self, instruction):
        if "ADD" in instruction and "ADDI" not in instruction:
            return self.encode_ADD(instruction)

        elif "ADDI" in instruction:
            return self.encode_ADDI(instruction)
          
        # elif "SUB" in instruction and "SUBI" not in instruction:
        #     return self.encode_SUB(instruction)
        
        # elif "AND" in instruction:
        #     return self.encode_AND(instruction)
        
        # ...

        
        
        # ...

        elif "EQ" in instruction:
            return self.encode_EQ(instruction)
        
        # ...

        else:
            raise ValueError(f"Unsupported instruction: {instruction}")
        
# regular expression:
# ^: begin; \s: space; \s*: repeated spaces; [a-z0-9]: means format like a0, a1, ..., z9; 
# 0x: hex imm; [a-fA-F0-9]: hex imm like 01C, 4D2,... FFF; \d: decimal imm like 0, 5,..., 13; $: end;
 
    def encode_ADD(self, instruction):
        if not re.match(r'^ADD+\s[r0-7]+$', instruction):   # a regular expression (ADD rs)
            raise ValueError(f"Syntax error in instruction: {instruction}")     
        tokens = instruction.split()        # splits the instruction string into a list, using spaces as the separator
        
        rs = self.registers.get(tokens[1])  # get the second token (rs)
        if rs is None:
            raise ValueError(f"Unknown register: {tokens[1]}")
        
        opcode = "000000"
        return opcode+rs
    
    # def encode_SUB(self, instruction):
    #     ...

    # def encode_AND(self, instruction):
    #     ...

    #     ...
    
    def encode_ADDI(self, instruction):
        if not re.match(r'^ADDI+\s(\d+)$', instruction):   # a regular expression (ADDI imm)
            raise ValueError(f"Syntax error in instruction: {instruction}")     
        tokens = instruction.split()    # splits the instruction string into a list, using spaces as the separator
        
        # get the second token (rt); 
        imm = bin(int(tokens[1]))[2:].zfill(3)  # zfill(length): pads a string on the left with zeros (0) until it reaches a specified length.
        if len(imm) > 3:
            raise ValueError(f"Immediate value out of bounds: {tokens[2]}")
        
        opcode = "010000"
        return opcode+imm
    
    # def encode_SUBI(self, instruction):
    #     ...ß

    # def encode_LWI(self, instruction):
    #     ...

    #     ...
    
    def encode_EQ(self, instruction):
        if not re.match(r'^EQ+\s[r0-7]+\s[r0-7]+$', instruction):   # a regular expression (EQ rs rt)
            raise ValueError(f"Syntax error in instruction: {instruction}")     
        tokens = instruction.split()    # splits the instruction string into a list, using spaces as the separator
        
        # get the second token (rs)
        rs = self.registers.get(tokens[1])  
        if rs is None:
            raise ValueError(f"Unknown register: {tokens[1]}")
        
        # get the third token (rt)
        rt = self.registers.get(tokens[2])
        if rt is None:
            raise ValueError(f"Unknown register: {tokens[1]}")
        
        opcode = "100"
        return opcode+rs+rt
    
    # def encode_LWRI(self, instruction):
    #     ...

    # def encode_JMP(self, instruction):
    #     ...
 
    def from_file(self, input_file="source.txt"):   # source assembly language file
        with open(input_file, 'r') as file:
            instructions = file.readlines()         # read instrutions line by line
            binary_codes = [self.encode(instruction.strip()) for instruction in instructions]
            with open("inst.txt", 'w') as out_file:       # output machine code file
                for code in binary_codes:
                    out_file.write(code + '\n')   # write machine code line by line

assembler = Assembler()
assembler.from_file()