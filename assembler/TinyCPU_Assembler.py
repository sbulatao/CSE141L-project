import re

'''
grammar:
1. Case insensitive for all instructions, registers and labels
2. Use ; in front of the comments
3. Allow blank lines
4. Use single or multiple blankspaces between instruction, register and immediate number
5. Do not use punctuations except comments
6. Put label on a separate line and end it with a colon

An example:
LWI 7	; ACC=7
MOV R1	; R1=7
LWI 3	; ACC=3
MOV  r2	; R2=3
LWI 2	; ACC=2
; begin computation
LABEL1:
XOR R1	; ACC=8'B0000_0010^8'B0000_0111=8'B0000_0101
XORI 6	; ACC=8'B0000_0101^8'B0000_0110=8'B0000_0011
SLL 6	; ACC=8'B1100_0000
STR R1	; MEM(R1)=MEM(8'B0000_0111)=8'B1100_0000
LWI 0	; CLEAR ACC=0
LWR R1	; ACC=MEM(R1)=MEM(8'B0000_0111)=8'B1100_0000
LWI 0	; CLEAR ACC=0
'''

class Assembler:
    def __init__(self):
        self.registers = {  # general purpose registers
            "R0": "000",
            "R1": "001",
            "R2": "010",
            "R3": "011",
            "R4": "100",
            "R5": "101",
            "R6": "110",
            "R7": "111",
        }
        self.symbol_table = {}
        self.instructions_for_second_pass = [] # Will store dicts: {'line_num': N, 'text': instruction_string, 'pc': pc_value}

    def _is_label_definition(self, line: str):
        stripped_line = line.strip()
        if stripped_line.endswith(':'):     # label always ends with :
            label_name = stripped_line[:-1].strip()
            if label_name and re.match(r'^[A-Z_][A-Z0-9_]*$', label_name, re.IGNORECASE): # Common label format
                return label_name.upper() # Store labels in uppercase
        return None

    # First pass: build symbol table and collect instructions with their PCs.
    def _first_pass(self, input_file="source_assembly.txt"):
        self.symbol_table.clear()
        self.instructions_for_second_pass.clear()
        current_pc = 0

        with open(input_file, 'r') as file:
            for line_number, raw_line in enumerate(file, 1):
                line = raw_line.strip()

                # Ignore empty lines
                if not line:
                    continue
                # Ignore full-line comments
                if line.startswith(';'):
                    continue
                # Remove inline comments
                comment_start_index = line.find(';')
                if comment_start_index != -1:
                    line = line[:comment_start_index].strip()
                # re-check
                if not line:
                    continue
                # Check for label definition
                label_name = self._is_label_definition(line)
                if label_name:  # For labels
                    if label_name in self.symbol_table: # Duplicated defination of a label
                        raise ValueError(f"Duplicate label definition '{label_name}'")
                    self.symbol_table[label_name] = current_pc
                else:           # For instructions
                    self.instructions_for_second_pass.append({
                        'line_num': line_number,
                        'text': line,   # Store the original cleaned instruction text
                        'pc': current_pc
                    })
                    current_pc += 1     # Increment PC for each actual instruction

    def encode_ADD(self, instruction_parts, line_num, pc):
        # instruction_parts: ['ADD', 'R1']
        if not (len(instruction_parts) == 2 and instruction_parts[1].upper() in self.registers):
            raise ValueError(f"Syntax error in ADD instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        opcode = "000000"
        return opcode + rs

    def encode_SUB(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].upper() in self.registers):
            raise ValueError(f"Syntax error in SUB instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        opcode = "000001"
        return opcode + rs

    def encode_AND(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].upper() in self.registers):
            raise ValueError(f"Syntax error in AND instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        opcode = "000010"
        return opcode + rs

    def encode_OR(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].upper() in self.registers):
            raise ValueError(f"Syntax error in OR instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        opcode = "000011"
        return opcode + rs

    def encode_XOR(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].upper() in self.registers):
            raise ValueError(f"Syntax error in OR instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        opcode = "000100"

        return opcode + rs
    def encode_BAN(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 1):
            raise ValueError(f"Syntax error in BAN instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = "000"
        opcode = "000101"
        return opcode + rs

    def encode_BOR(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 1):
            raise ValueError(f"Syntax error in BOR instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = "000"
        opcode = "000110"
        return opcode + rs

    def encode_LWR(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].upper() in self.registers):
            raise ValueError(f"Syntax error in LWR instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        opcode = "001000"
        return opcode + rs

    def encode_STR(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].upper() in self.registers):
            raise ValueError(f"Syntax error in STR instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        opcode = "001001"
        return opcode + rs

    def encode_ADDI(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].isdigit()):
            raise ValueError(f"Syntax error in ADDI instruction at line {line_num}: { ' '.join(instruction_parts)}")
        imm_val = int(instruction_parts[1])
        if not (0 <= imm_val <= 7): # Assuming 3-bit immediate
            raise ValueError(f"Immediate value out of bounds (0-7) for ADDI at line {line_num}: {imm_val}")
        imm = bin(imm_val)[2:].zfill(3)
        opcode = "010000"
        return opcode + imm

    def encode_SUBI(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].isdigit()):
            raise ValueError(f"Syntax error in SUBI instruction at line {line_num}: { ' '.join(instruction_parts)}")
        imm_val = int(instruction_parts[1])
        if not (0 <= imm_val <= 7): # Assuming 3-bit immediate
            raise ValueError(f"Immediate value out of bounds (0-7) for SUBI at line {line_num}: {imm_val}")
        imm = bin(imm_val)[2:].zfill(3)
        opcode = "010001"
        return opcode + imm

    def encode_LWI(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].isdigit()):
            raise ValueError(f"Syntax error in LWI instruction at line {line_num}: { ' '.join(instruction_parts)}")
        imm_val = int(instruction_parts[1])
        if not (0 <= imm_val <= 7): # Assuming 3-bit immediate
            raise ValueError(f"Immediate value out of bounds (0-7) for LWI at line {line_num}: {imm_val}")
        imm = bin(imm_val)[2:].zfill(3)
        opcode = "010010"
        return opcode + imm

    def encode_XORI(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].isdigit()):
            raise ValueError(f"Syntax error in SUBI instruction at line {line_num}: { ' '.join(instruction_parts)}")
        imm_val = int(instruction_parts[1])
        if not (0 <= imm_val <= 7): # Assuming 3-bit immediate
            raise ValueError(f"Immediate value out of bounds (0-7) for SUBI at line {line_num}: {imm_val}")
        imm = bin(imm_val)[2:].zfill(3)
        opcode = "010011"
        return opcode + imm

    def encode_BRC(self, instruction_parts, line_num, current_instruction_pc):
        if not (len(instruction_parts) == 2):
            raise ValueError(f"Syntax error in BRC instruction at line {line_num}: { ' '.join(instruction_parts)}. Expected BRC LABEL_NAME")
        
        label_name = instruction_parts[1].upper()
        if label_name not in self.symbol_table:
            raise ValueError(f"Undefined label '{label_name}' in BRC instruction at line {line_num} (PC {current_instruction_pc})")

        target_pc = self.symbol_table[label_name]
        offset = target_pc - (current_instruction_pc + 1)

        if not (0 <= offset <= 7): # 3-bit signed offset range
             raise ValueError(f"BRC offset {offset} for label '{label_name}' out of 3-bit signed range (0 to 7) at line {line_num}.")
        else:
            offset_bin = bin(offset)[2:].zfill(3)
        
        opcode = "010101"
        return opcode + offset_bin

    def encode_SLL(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and instruction_parts[1].isdigit()):
            raise ValueError(f"Syntax error in SLL instruction at line {line_num}: { ' '.join(instruction_parts)}")
        imm_val = int(instruction_parts[1])
        if not (0 <= imm_val <= 7): # Assuming 3-bit immediate
            raise ValueError(f"Immediate value out of bounds (0-7) for SLL at line {line_num}: {imm_val}")
        imm = bin(imm_val)[2:].zfill(3)
        opcode = "010111"
        return opcode + imm

    def encode_EQ(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 3 and
                instruction_parts[1].upper() in self.registers and
                instruction_parts[2].upper() in self.registers):
            raise ValueError(f"Syntax error in EQ instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        rt = self.registers[instruction_parts[2].upper()]
        opcode = "100"
        return opcode + rs + rt

    def encode_MOV(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 2 and
                instruction_parts[1].upper() in self.registers):
            raise ValueError(f"Syntax error in LWRI instruction at line {line_num}: { ' '.join(instruction_parts)}")
        rs = self.registers[instruction_parts[1].upper()]
        opcode = "101"
        d = "000"
        return opcode + d + rs
    
    def encode_JR(self, instruction_parts, line_num, pc):
        if not (len(instruction_parts) == 1):
            raise ValueError(f"Syntax error in JR instruction at line {line_num}: { ' '.join(instruction_parts)}")
        opcode = "110"
        d = "000000"
        return opcode + d

    def encode_JMP(self, instruction_parts, line_num, current_instruction_pc):
        if not (len(instruction_parts) == 2):
            raise ValueError(f"Syntax error in JMP instruction at line {line_num}: { ' '.join(instruction_parts)}. Expected JMP LABEL_NAME")

        label_name = instruction_parts[1].upper()
        if label_name not in self.symbol_table:
            raise ValueError(f"Undefined label '{label_name}' in JMP instruction at line {line_num} (PC {current_instruction_pc})")

        target_address = self.symbol_table[label_name]

        if not (0 <= target_address <= 63*4): # Max for 6 bits
            raise ValueError(f"JMP target address {target_address} for label '{label_name}' out of 6-bit range (0-63) at line {line_num}.")
        
        target_bin = bin(target_address)[2:].zfill(6)
        opcode = "111"
        return opcode + target_bin

    def encode(self, instruction_text, current_instruction_pc, line_num):
        parts = instruction_text.strip().upper().split() 
        if not parts:
            raise ValueError(f"Empty instruction encountered at line {line_num} (PC {current_instruction_pc})")

        opcode_name = parts[0]

        if opcode_name == "ADD":
            return self.encode_ADD(parts, line_num, current_instruction_pc)
        elif opcode_name == "SUB":
            return self.encode_SUB(parts, line_num, current_instruction_pc)
        elif opcode_name == "AND":
            return self.encode_AND(parts, line_num, current_instruction_pc)
        elif opcode_name == "OR":
            return self.encode_OR(parts, line_num, current_instruction_pc)
        elif opcode_name == "XOR":
            return self.encode_XOR(parts, line_num, current_instruction_pc)
        elif opcode_name == "BAN":
            return self.encode_BAN(parts, line_num, current_instruction_pc)
        elif opcode_name == "BOR":
            return self.encode_BOR(parts, line_num, current_instruction_pc)
        elif opcode_name == "LWR":
            return self.encode_LWR(parts, line_num, current_instruction_pc)
        elif opcode_name == "STR":
            return self.encode_STR(parts, line_num, current_instruction_pc)
        elif opcode_name == "ADDI":
            return self.encode_ADDI(parts, line_num, current_instruction_pc)
        elif opcode_name == "SUBI":
            return self.encode_SUBI(parts, line_num, current_instruction_pc)
        elif opcode_name == "LWI":
            return self.encode_LWI(parts, line_num, current_instruction_pc)
        elif opcode_name == "XORI":
            return self.encode_XORI(parts, line_num, current_instruction_pc)
        elif opcode_name == "BRC":
            return self.encode_BRC(parts, line_num, current_instruction_pc)
        elif opcode_name == "SLL":
            return self.encode_SLL(parts, line_num, current_instruction_pc)
        elif opcode_name == "EQ":
            return self.encode_EQ(parts, line_num, current_instruction_pc)
        elif opcode_name == "MOV":
            return self.encode_MOV(parts, line_num, current_instruction_pc)
        elif opcode_name == "JR":
            return self.encode_JR(parts, line_num, current_instruction_pc)
        elif opcode_name == "JMP":
            return self.encode_JMP(parts, line_num, current_instruction_pc)
        else:
            raise ValueError(f"Unsupported instruction: '{opcode_name}' at line {line_num} (PC {current_instruction_pc})")
    
    # Second pass: generate machine code using the symbol table.
    def _second_pass(self):
        binary_codes = []
        for inst_info in self.instructions_for_second_pass:
            instruction_text = inst_info['text']
            instruction_pc = inst_info['pc']
            line_num = inst_info['line_num']
            try:
                machine_code = self.encode(instruction_text, instruction_pc, line_num)
                if machine_code:
                    binary_codes.append(machine_code)
                # else: # This path should ideally not be taken if encode raises errors properly
                #     print(f"Warning: No machine code generated for instruction at line {line_num}: '{instruction_text}'")
            except ValueError as e:
                # print(f"Assembly Error: {e}") # Printing is handled in from_file
                binary_codes.append(f"; ERROR line {line_num} (PC {instruction_pc}): {e}")
        return binary_codes


    def from_file(self, input_file="source_assembly.txt", output_file="inst.txt"):
        # Pass 1: Build Symbol Table
        print(f"Starting First Pass on '{input_file}'...")
        self._first_pass(input_file) # Reads from input_file
        print("First Pass Complete.")
        print("Symbol Table:")
        if not self.symbol_table:
            print("  (empty)")
        else:
            for label, addr in self.symbol_table.items():
                print(f"  {label}: {addr}")

        # Pass 2: Generate Machine Code
        print("\nStarting Second Pass...")
        binary_codes = self._second_pass() # Uses data from self.instructions_for_second_pass
        print("Second Pass Complete.")

        # Write to output file
        num_errors = 0
        with open(output_file, 'w') as out_file:
            for code in binary_codes:
                out_file.write(code + '\n')
                if code.startswith("; ERROR"):
                    num_errors +=1
        
        if num_errors > 0:
            print(f"\nAssembly completed with {num_errors} error(s). Machine code (with error markers) written to '{output_file}'")
            for code in binary_codes: # Print errors to console as well
                if code.startswith("; ERROR"):
                    print(code)
        else:
            print(f"\nAssembly successful. Machine code written to '{output_file}'")

assembler = Assembler()
assembler.from_file("source_assembly.txt", "inst.txt") # Default input "source_assembly.txt", output "inst.txt"
