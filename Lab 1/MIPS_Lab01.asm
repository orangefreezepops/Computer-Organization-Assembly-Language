.text 
addi $t4,$zero,3
addi $t4,$t4,5
addi $t4,$t4,8

.data
.word 0x25,0x3,16,25,3,0x44,0x33,0x22,44,33,22


.data
message: .asciiz "Hello, world!" 
.text

li $v0, 4
la $a0, message
syscall



