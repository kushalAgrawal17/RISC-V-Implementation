
.data
instruction: .word 0x005180b3
address: .word 0x10001000

.text
beq x0 x0 main # go to main

store_opcode: # storing opcode
sw x6 0(x4)
addi x4 x4 4
jalr x0 x1 0 #return

store_rd: #extracting rd
srli x8 x5 7
andi x8 x8 31
sw x8 0(x4) #storing rd
addi x4 x4 4
jalr x0 x1 0

store_funct3:  #extracting funct3
srli x8 x5 12
andi x8 x8 7
sw x8 0(x4) #storing funct3
addi x4 x4 4
jalr x0 x1 0

store_rs1:  #extracting rs1
srli x8 x5 15
andi x8 x8 31
sw x8 0(x4) #storing rs1
addi x4 x4 4
jalr x0 x1 0

store_rs2:  #extracting rs2
srli x8 x5 20
andi x8 x8 31
sw x8 0(x4) #storing rs2
addi x4 x4 4
jalr x0 x1 0

store_funct7:  #extracting funct7
srli x8 x5 25
sw x8 0(x4) #storing funct7
addi x4 x4 4
jalr x0 x1 0

store_imm_Itype:  #extracting imm for I-type instruction
srli x8 x5 20
sw x8 0(x4) #storing imm
addi x4 x4 4
jalr x0 x1 0

store_imm_Stype: #extracting imm for S-type instruction
srli x11 x5 25 # extracting imm[11-5]
slli x11 x11 5 
srli x12 x5 7 # extracting imm[4-0]
andi x12 x12 31
add x8 x11 x12 #final imm value extracted
sw x8 0(x4) #storing imm
addi x4 x4 4
jalr x0 x1 0

store_imm_SBtype: #extracting imm for SB-type instruction
srli x11 x5 8
andi x11 x11 15 # extracting imm[4-1]

srli x12 x5 25 # extracting imm[10-6]
andi x12 x12 63
slli x12 x12 4 
add x8 x11 x12 #extracted imm[10-1]

srli x12 x5 7 # extracting imm[11]
andi x12 x12 1
slli x12 x12 10
add x8 x8 x12 #extracted imm[11-1]

srli x12 x5 31 # extracting imm[12]
slli x12 x12 11
add x8 x8 x12 #extracted imm[12-1], final value extracted

sw x8 0(x4) #storing imm
addi x4 x4 4
jalr x0 x1 0


main:
lw x4 address
lw x5 instruction
andi x6 x5 127 #extracting opcode
case1: #opcode = 51, add instruction
addi x7 x0 51 
bne x6 x7 case2
jal x1 store_opcode #the order in which the values are stored at the given address is same as the order in which the respective functions are called
jal x1 store_rd
jal x1 store_funct3
jal x1 store_rs1
jal x1 store_rs2
jal x1 store_funct7
beq x0 x0 exit

case2: #opcode = 19, slti instruction
addi x7 x0 19
bne x6 x7 case3
jal x1 store_opcode
jal x1 store_rd
jal x1 store_funct3
jal x1 store_rs1
jal x1 store_imm_Itype
beq x0 x0 exit

case3: #opcode = 3, lw instruction
addi x7 x0 3
bne x6 x7 case4
jal x1 store_opcode
jal x1 store_rd
jal x1 store_funct3
jal x1 store_rs1
jal x1 store_imm_Itype
beq x0 x0 exit

case4: #opcode = 35, sw instruction
addi x7 x0 35
bne x6 x7 case5
jal x1 store_opcode
jal x1 store_funct3
jal x1 store_rs1
jal x1 store_rs2
jal x1 store_imm_Stype
beq x0 x0 exit

case5: #opcode = 99, beq instruction
jal x1 store_opcode
jal x1 store_funct3
jal x1 store_rs1
jal x1 store_rs2
jal x1 store_imm_SBtype

exit:


