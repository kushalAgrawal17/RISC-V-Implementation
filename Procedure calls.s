
#sequence input should not start or end with a space, and there should be a single space between each {E,D,S,number to be enqueued}
.data
sequence: .string "E 20 E 12 E 9 D D S E 23 E 17" #input sequence
startaddress: .word 0x10001000 #starting address of the queue
address2: .word 0x10005000 #to store size of the queue 

.text
beq x0 x0 main

getlength: # function to get the length of number to be enqueued (useful in converting string of characters to integer value)
addi x15 x0 0
addi x12 x0 32 # x12 has ascii code for " "
addi x25 x0 45 # "-" sign
addi x26 x0 1
loop2:
lb x11 0(x4)
bne x11 x25 positivenumber
addi x26 x0 -1
addi x4 x4 1
beq x0 x0 loop2
positivenumber:
bne x11 x12 next #x11 is not " "
returnLength:
addi x4 x4 -1
jalr x0 x1 0
next:
beq x11 x0 returnLength #if x11 is end of string i.e null then return
addi x15 x15 1
addi x4 x4 1
beq x0 x0 loop2

getint: # to convert characters to integers (example: "20" -> 20)
addi x16 x15 0
addi x17 x0 1
addi x19 x0 10
addi x20 x0 0
loop3:
lb x11 0(x4)
beq x16 x0 returnValue #if x16 = 0 the final value has been calculated, so return
addi x11 x11 -48
mul x18 x17 x11
mul x17 x17 x19
add x20 x20 x18 # final int value will be store in x20
addi x4 x4 -1
addi x16 x16 -1
beq x0 x0 loop3
returnValue:
addi x16 x15 2
add x4 x4 x16 # setting value of x4 such that the address in x4 contains the next procedural instruction
mul x20 x20 x26
jalr x0 x1 0 #return

dequeue: # function to dequeue
addi x21 x5 0
loop4:
addi x22 x21 4 # address x22 stores next element of the queue
lw x23 0(x22) # loading word from address x22
sw x23 0(x21) # storing at x21(thie helps in keeping the starting address x5 same all the time)
addi x21 x21 4
bne x22 x6 loop4 # checks if shifting all elements has completed
sw x0 0(x22)
addi x6 x6 -4 #updating x6 after dequeuing
jalr x0 x1 0 #return

main:
lw x7 address2
la x4 sequence
lw x5 startaddress
addi x6 x5 0  #x6 stores end-address of queue initially equal to start-address
loop1:
lb x11 0(x4) #loading from x4 address into x11
beq x11 x0 exit #if string ends then exit
addi x4 x4 2 # incrementing by 2- one for procedure{E/D/S} and other for space{" "}

caseEnqueue:
addi x9 x0 69 #E
bne x11 x9 caseDequeue #procedure is not E
jal x1 getlength
jal x1 getint
sw x20 0(x6) #enqueue x20 (x20 has the value to be enqueued)
addi x6 x6 4 #updating end-address
beq x0 x0 loop1

caseDequeue:
addi x9 x0 68 #D
bne x11 x9 caseSize #procedure is not D
beq x5 x6 empty # x5 = x6 which means the queue is empty, no need to modify the queue
jal x1 dequeue
empty:
beq x0 x0 loop1

caseSize: #S
sub x10 x6 x5
srli x10 x10 2 # x10 = x10 / 4 (as 1 word takes 4 bytes)
sw x10 0(x7) # store size of queue in given address
beq x0 x0 loop1

exit:
