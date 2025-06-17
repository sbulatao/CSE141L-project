# CSE141L-project
# ISA Documentation


---

## Instruction Formats

| Type | Format                      | Corresponding Instructions       |
|------|-----------------------------|----------------------------------|
| SR   | 6-bit op, 3-bit rs<br>6-bit op, 3-bit don't care | ADD, SUB, AND, OR, XOR, SRLR<br>BAN, BOR |
| LS   | 6-bit op, 3-bit rs          | LWR, STR                         |
| SI   | 6-bit op, 3-bit imm         | ADDI, SUBI, LWI, BRC, SRL, SLL |
| DR   | 3-bit op, 3-bit rs, 3-bit rt| EQ                               |
| GR   | 3-bit op, 3-bit don't care, 3-bit rs         | MOV            |
| J    | 3-bit op, 6-bit target      | JR JMP                           |

---

## Operations

| NAME | TYPE | BIT BREAKDOWN | EXAMPLE | NOTES |
|------|------|----------------|---------|-------|
| ADD | SR | 000000_xxx<br>6-bit op=000000<br>3-bit rs =xxx | 000000_001<br># Assume Acc = 0000_0010<br># Assume rf[001] = 0000_0001<br># After ADD, Acc = 0000_0011 | Acc = Acc + rs |
| SUB | SR | 000001_xxx<br>6-bit op=000001<br>3-bit rs =xxx | 000001_010<br># Assume Acc = 0000_0011<br># Assume rf[010] = 0000_0001<br># After SUB, Acc = 0000_0010 | Acc = Acc - rs |
| AND | SR | 000010_xxx<br>6-bit op=000010<br>3-bit rs =xxx | 000010_011<br># Assume Acc = 1100_1100<br># Assume rf[011] = 1010_1010<br># After AND, Acc = 1000_1000 | Acc = Acc & rs |
| OR | SR | 000011_xxx<br>6-bit op=000011<br>3-bit rs =xxx | 000011_010<br># Assume Acc = 0000_0100<br># Assume rf[010] = 0000_0010<br># After OR, Acc = 0000_0110 | Acc = Acc \| rs |
| XOR | SR | 000100_xxx<br>6-bit op=000100<br>3-bit rs =xxx | 000100_010<br># Assume Acc = 0000_1111<br># Assume rf[010] = 0000_0010<br># After XOR, Acc = 0000_1101 | Acc = Acc ^ rs |
| BAN | SR | 000101_xxx<br>6-bit op=000101<br>3-bit xxx are useless | 000101_xxx<br># Assume Acc = 1010_1010<br># After BAN, Acc = 0000_0000 | Acc = &Acc |
| BOR | SR | 000110_xxx<br>6-bit op=000110<br>3-bit xxx are useless | 000110_xxx<br># Assume Acc = 1010_0000<br># After BOR, Acc = 0000_0001 | Acc = \|Acc |
| SRLR | SR | 000111_xxx<br>6-bit op=000111<br>3-bit rs =xxx | 000111_010<br># Assume Acc = 0011_0000<br># Assume rf[010] = 0000_0011<br># After SLLR, Acc = 0000_0110 | Acc = Acc >> rs |
| LWR | LS | 001000_xxx<br>6-bit op=001000<br>3-bit rs =xxx | 001000_001<br># Assume MEM(rf[001]) = 0101_0101<br># After LWR, Acc = 0101_0101 | Acc = MEM(rs) |
| STR | LS | 001001_xxx<br>6-bit op=001001<br>3-bit rs =xxx | 001001_001<br># Assume Acc = 0000_1010<br># After STR, MEM(rf[001]) = 0000_1010 | MEM(rs) = Acc |
| ADDI | SI | 010000_xxx<br>6-bit op=010000<br>3-bit imm = xxx | 010000_100<br># Assume Acc = 0000_0010<br># imm = 100<br># After ADDI, Acc = 0000_0110 | Acc = Acc + imm |
| SUBI | SI | 010001_xxx<br>6-bit op=010001<br>3-bit imm = xxx | 010001_010<br># Assume Acc = 0000_0110<br># imm = 010<br># After SUBI, Acc = 0000_0100 | Acc = Acc - imm |
| LWI | SI | 010010_xxx<br>6-bit op=010010<br>3-bit imm = xxx | 010010_111<br># Assume Acc = 0000_0000<br># imm = 111<br># After LWI, Acc = 0000_0111 | Acc = imm |
| BRC | SI | 010101_xxx<br>6-bit op=010101<br>3-bit imm = xxx | 010101_010<br># Assume BranchFlag = 1<br># offset = 010<br># Then PC = PC + 1 + 2 | if(BranchFlag == 1) PC = PC + 1 + imm |
| SRL | SI | 010110_xxx<br>6-bit op=010110<br>3-bit imm = xxx | 010110_010<br># Assume Acc = 0000_1000<br># imm = 011<br># After SLL, Acc = 0000_0001 | Acc = Acc >> imm |
| SLL | SI | 010111_xxx<br>6-bit op=010111<br>3-bit imm = xxx | 010111_010<br># Assume Acc = 0000_0010<br># imm = 010<br># After SLL, Acc = 0000_1000 | Acc = Acc << imm |
| EQ | DR | 100_xxx_yyy<br>3-bit op = 100<br>3-bit rs = xxx<br>3-bit rt = yyy | 100_101_100<br># rs = 101<br># rt = 100<br># rf[101] == rf[100]<br># BranchFlag = 1 | if(rs == rt) BranchFlag = 1 |
| MOV | GR | 101_ddd_xxx<br>3-bit op=101<br>3-bit ddd<br>3-bit rs xxx| 101_000_001<br># Assume rs = 001<br># Assume acc = 0000_0011<br># rf[001] = 0000_0011 | rs = acc |
| JR | J | 110_ddd_ddd<br>3-bit op=110<br>6-bit ddd are useless<br> | 110_ddd_ddd<br>assume acc = 0010_1001<br> # PC = acc = 0010_1001 | PC = acc|
| JMP | J | 111_xxxxxx<br>3-bit op=111<br>6-bit target = xxxxxx | 111_001101<br># PC = target= 001101 | PC = target |

---

## Internal Operands

- **General Purpose Registers**: 8-bit `r0` to `r7`
- **Special Purpose Registers**: 
  - 8-bit `acc` (Accumulator)
  - 8-bit `BranchFlag` (Used for conditional branching)
  - 8-bit `pc` (Program Counter)

## Simulation Guidance
- Simulation
  - We just use EDAPlayground as simulator.
  - Upload the /program1/new_int2flt_tb.sv into the testbench section to be the testbench.sv file.
  - Upload /src/top.v into design section to be the design.sv file. Upload /program1/new_int2flt_tb.sv and all other programs in the /src/* except top_tb.v into the design section.
  - Select IVerilog as simulator, finally you can run the test.
- Use the assembler to assembly your own assembly code.
  - Upload the assembly program and name it source_assembly.txt, strictly follow the grammar.
  - Run python program /assembler/TinyCPU_Assembler.py, the machine code will be updated in inst.txt.
  - Replace the /src/inst.txt with the updated /assembler/inst.txt
  - Now you can do simulation work.
- assembly code grammar
  - Case insensitive for all instructions, registers and labels.
  - Use ; in front of the comments.
  - Allow blank lines.
  - Use single or multiple blankspaces between instruction, register and immediate number.
  - Do not use punctuations except comments and labels.
  - Put label on a separate line and end it with a colon.

---
