.data

chars:	.byte 0x41,0x42,0x43,0x44,0x45,0x00
msg1:	.asciiz "First Message"
# hex:	46 69 72 73 74 20 4D 65 73 73 61 67 65 00
space:	.asciiz " "
# hex:	20 00
return:	.asciiz "\n"
# hex:	0A 00
msg2:	.asciiz "The value of $t0 is"	
# hex:	54 68 65 20 76 61 6C 75  65 20 6F 66 20 24 74 30 20 69 73 00

nums:	.word 0x41,0x42,0x43,0x44

.text

# An example: printing null-terminated strings and integers
addi $t0,$zero,55   
addi $v0,$zero,4		
la $a0,msg2
syscall							
la $a0,space
syscall
addi $v0,$zero,1
addi $a0,$t0,0
syscall
addi $v0,$zero,4	
la $a0,return
syscall
	
# practice with loading and storing words and bytes
la $t0,nums  
lw $t1,12($t0)  
lw $t2,4($t0)  
lw $t3,0($t0)  
addi $t3,$t3,8 
sw $t3,0($t0)  
sw $t2,12($t0) 
lb $t5,0($t0) 
lb $t6,1($t0) 
sb $t5,24($t0)

# Now some nonsense code to help in understanding exactly what is stored where

la $t0,msg1
lb $t3,0($t0)
lb $t4,1($t0)
la $t5,nums
sb $t3,12($t5)
addi $t3,$t3,2
sb $t3,13($t5)
addi $t3,$t3,2				
sb $t3,14($t5)
addi $t3,$t3,2				
sb $t3,15($t5)
sw $t3,16($t5)

addi $v0,$zero,4	
la $a0,msg1
syscall

addi $v0,$zero,4
la $a0,return
syscall

la $a0,msg1
addi $v0,$zero,1
syscall

addi $v0,$zero,4
la $a0,return
syscall

la $t0,msg1
lb $t2,2($t0)	
addi $t2,$t2,2
sb $t2,2($t0)
la $a0,msg1
addi $v0,$zero,4
syscall

addi $v0,$zero,4
la $a0,return
syscall

# do some stuff with the chars array

la $t0,chars

la $a0,chars
addi $v0,$zero,4	
syscall

addi $v0,$zero,4
la $a0,return
syscall

addi $t1,$zero,0x46
sb $t1,5($t0)
sb $zero,6($t0)

la $a0,chars
addi $v0,$zero,4	
syscall
