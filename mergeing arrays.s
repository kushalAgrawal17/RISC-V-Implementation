#Kushal Agrawal
#2020CSB1096
.data
n1: .word 10 #size of array 1
n2: .word 6 #size of array 2
array1: .word 5 6 10 13 15 16 36 45 57 88	#initializing array 1
array2: .word 1 2 4 7 9 11 	 #initializing array 2
newaddress: .word 0x10001000 	#address where the sorted array is to be stored

.text
la x11 array1 # x11 has the starting address of array1
la x12 array2 # x12 has the starting address of array2
lw x9 n1 
lw x10 n2 
lw x7 newaddress

loop:
lw x15 0(x11)
lw x16 0(x12)
beq x9 x0 case1 #if all elements of array1 are taken into the new array then x9=0 (now we need to fill the remaining elements of array2 in the new array)
beq x10 x0 case2 #if all elements of array2 are taken into the new array then x10=0 (now we need to fill the remaining elements of array1 in the new array)
blt x15 x16 case2 #if x15 is less than x16 then push x15 in the new array

case1: #push x16 in the new array
beq x10 x0 exit #elements of both arrays have been pushed to new array, so exit code 
sw x16 0(x7)
addi x7 x7 4
addi x12 x12 4 #updating array2 pointer
addi x10 x10 -1 #x10 stores number of elements left in array 2
beq x0 x0 loop

case2: #push x15 in the new array
beq x9 x0 exit #elements of both arrays have been pushed to new array, so exit code 
sw x15 0(x7)
addi x7 x7 4
addi x11 x11 4 #updating array1 pointer
addi x9 x9 -1 #x9 stores number of elements left in array 1
beq x0 x0 loop

exit:
