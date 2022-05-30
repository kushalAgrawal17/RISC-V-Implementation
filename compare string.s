# Kushal Agrawal
# 2020CSB1096
.data
n: .word 12
string1: .string "heyhowareYou"
string2: .string "helloIareyou"
address1 :.word 0x10001000 # for string1 
address2 :.word 0x10002000 # for string2 

.text
beq x0 x0 main

store_string: #function to store string at a given address
addi x6 x0 0 #initializing x6 to 0
addi x22 x0 65 # x22 stores "A" i.e 65
addi x23 x0 90 #x23 stores "Z" i.e 90
loop1:
beq x9 x6 return
lb x13 0(x11)
bgt x13 x23 next # if x13 is greater than 90 then goto next
blt x13 x22 next # if x13 is less than 65 then go to next
addi x13 x13 32 # converting upper-case letter to lower-case as programm is not case-sensitive
next:
sb x13 0(x12)
addi x11 x11 1 #incrementing x11 to next byte address
addi x12 x12 1 #incrementing x12 to next byte address
addi x6 x6 1 #incrementing x6 by 1
beq x0 x0 loop1
return:
jalr x0 x1 0 #return


main:
lw x9 n # x9 has length of string
la x11 string1
lw x12 address1 #address at which we want to store the str1
jal x1 store_string
la x11 string2
lw x12 address2 #address at which we want to store the str1
jal x1 store_string

addi x7 x0 0 #initializing x7 to 0
addi x6 x0 0 #initializing x6 to 0,  x6 stores the number of characters compared so far
lw x11 address1 #loading add1 in x11
lw x12 address2 #loading add2 in x12
loop2:
beq x9 x6 exit # true when comparing the strings has been completed
lb x13 0(x11) # x13 has a character from str1
lb x14 0(x12) # x14 has a character from str2 from the same position as x13
beq x13 x14 comparenext # true if x13 = x14
addi x7 x7 1 # this instruction is executed when both characters are different
comparenext:
addi x11 x11 1 #incrementing x11 to next byte address
addi x12 x12 1 #incrementing x12 to next byte address
addi x6 x6 1
beq x0 x0 loop2

exit: