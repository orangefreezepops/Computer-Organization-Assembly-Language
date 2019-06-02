# i = 1
# k = 5
# while (save{i} == k
# i += 1

.data
	save: .word 5,5,5,5,7,6,6,7
#the array is called save so e.g. save{0} is 5, save{4} is 7
#each is one word because we use the .word directive

.text 
	li $s3, 1
	la $s6, save
	li $s5, 5
loop:
	sll $t1, $s3, 2
	add $t1, $t1, $s6
	
	lw $t0, 0($t1)
	bne $t0, $s5, exitloop
	addi $s3, $s3, 1
	j loop
exitloop:
	add $s6, $s3, $zero
#
#
