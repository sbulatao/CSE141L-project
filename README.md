# CSE141L-project
# Instruction Set Architecture (ISA) Documentation

This document describes the instruction formats, corresponding operations, and operand usage for a custom instruction set architecture.

---

## Instruction Formats

| Type | Format                      | Corresponding Instructions       |
|------|-----------------------------|----------------------------------|
| SR   | 6-bit op, 3-bit rs          | ADD, SUB, AND, OR, BAN, BOR      |
| LS   | 6-bit op, 3-bit rs          | LWR, STR                         |
| SI   | 6-bit op, 3-bit imm         | ADDI, SUBI, LWI, BRC, SLL        |
| DR   | 3-bit op, 3-bit rs, 3-bit rt| EQ                               |
| RI   | 3-bit op, 3-bit rs, 3-bit imm | LWRI                           |
| J    | 3-bit op, 6-bit target      | JMP                              |

---

## Operations

| NAME  | TYPE | BIT BREAKDOWN | EXAMPLE     | NOTES |
|-------|------|----------------|-------------|-------|
| ADD   | SR   | 000000_xxx     | 000000_001  | Acc = Acc + rs<br>6-bit op=000000<br># Assume Acc = 0000_0010<br>3-bit rs = xxx<br># Assume rf[001] = 0000_0001<br># After ADD, Acc = 0000_0011 |
| SUB   | SR   | 000001_xxx     | 000001_010  | Acc = Acc - rs<br>6-bit op=000001<br># Assume Acc = 0000_0011<br>3-bit rs = xxx<br># Assume rf[010] = 0000_0001<br># After SUB, Acc = 0000_0010 |
| AND   | SR   | 000010_xxx     | 000010_011  | Acc = Acc & rs<br>6-bit op=000010<br># Assume Acc = 1100_1100<br>3-bit rs = xxx<br># Assume rf[011] = 1010_1010<br># After AND, Acc = 1000_1000 |
| OR    | SR   | 000011_xxx     | 000011_010  | Acc = Acc \| rs<br>6-bit op=000011<br># Assume Acc = 0000_0100<br>3-bit rs = xxx<br># Assume rf[010] = 0000_0010<br># After OR, Acc = 0000_0110 |
| BAN   | SR   | 000101_xxx     | 000101_xxx  | Acc = &Acc<br>6-bit op=000101<br># Assume Acc = 1010_1010<br>3-bit xxx are useless<br># After BAN, Acc = 0000_0000 |
| BOR   | SR   | 000110_xxx     | 000110_xxx  | Acc = \|Acc<br>6-bit op=000110<br># Assume Acc = 1010_0000<br>3-bit xxx are useless<br># After BOR, Acc = 0000_0001 |
| LWR   | LS   | 001000_xxx     | 001000_001  | Acc = MEM(rs)<br>6-bit op=001000<br># Assume MEM(rf[001]) = 0101_0101<br>3-bit rs = xxx<br># After LWR, Acc = 0101_0101 |
| STR   | LS   | 001001_xxx     | 001001_001  | MEM(rs) = Acc<br>6-bit op=001001<br># Assume Acc = 0000_1010<br>3-bit rs = xxx<br># After STR, MEM(rf[001]) = 0000_1010 |
| ADDI  | SI   | 010000_xxx     | 010000_100  | Acc = Acc + imm<br>6-bit op=010000<br># Assume Acc = 0000_0010<br>3-bit imm = xxx (100)<br># After ADDI, Acc = 0000_0110 |
| SUBI  | SI   | 010001_xxx     | 010001_010  | Acc = Acc - imm<br>6-bit op=010001<br># Assume Acc = 0000_0110<br>3-bit imm = xxx (010)<br># After SUBI, Acc = 0000_0100 |
| LWI   | SI   | 010010_xxx     | 010010_111  | Acc = imm<br>6-bit op=010010<br># Assume Acc = 0000_0000<br>3-bit imm = xxx (111)<br># After LWI, Acc = 0000_0111 |
| BRC   | SI   | 010101_xxx     | 010101_010  | if (BranchFlag == 1) PC = PC + 1 + imm<br>else PC = PC + 1<br>6-bit op=010101<br>3-bit imm = xxx (010)<br># Assume BranchFlag = 1<br># Then PC = PC + 1 + 2 |
| SLL   | SI   | 010111_xxx     | 010011_010  | Acc = Acc << imm<br>6-bit op=010111<br># Assume Acc = 0000_0010<br>3-bit imm = xxx (010)<br># After SLL, Acc = 0000_1000 |
| EQ    | DR   | 100_xxx_yyy    | 100_101_100 | if (rs == rt) BranchFlag = 1<br>else BranchFlag = 0<br>3-bit op=100<br>rs = 101, rt = 100<br># Since rf[101] == rf[100], BranchFlag = 1 |
| LWRI  | RI   | 101_xxx_yyy    | 101_001_011 | rs = imm<br>3-bit rs = xxx (001)<br>3-bit imm = yyy (011)<br># rf[001] = 0000_0011 |
| JMP   | J    | 111_xxxxxx     | 111_001101  | PC = target<br>6-bit target = xxxxxx<br># PC = target << 2 = 0011_0100 |

---

## Internal Operands

- **General Purpose Registers**: `r0` to `r7` (with `r0` hardwired to 0)
- **Special Purpose Registers**:
  - `acc` (Accumulator)
  - `BranchFlag` (Used for conditional branching)
  - `pc` (Program Counter)

---
