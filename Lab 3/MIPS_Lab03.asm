.data
	c: .word 5
	k: .word 3
.text
	la $t0, c
	la $t1, k
	lw $s0, 0($t0)
	lw $s1, 0($t1)
	slt $s3, $s0, $s1
	beq $s3, $0, notless
	
	sw $s0, 0($t1)
	sw $s1, 0($t0)
notless:
	addi $v0, $0, 5	