.data
	array1:
		.word 3,5,7,9,10,8,6,4
.text
	main:
		la $a0, array1
		addi $a1, $zero, 8
		jal maximum
		j finish
		
	maximum:
		addi $t7, $zero, 0
		addi $t2, $zero, 0
		
		maximum_loop:
			beq $t7, $a1, maximum_finish
			lw $t3, 0($a0)
			slt $t1, $t3, $t2
			
			bne $t1, $zero, notmore
			addi $t2, $t3, 0
		notmore:
			addi $t7, $t7, 1
			addi $a0, $a0, 4
			j maximum_loop
		
		maximum_finish:
			jr $ra
	
	finish:
		addi $a2, $t2, 0