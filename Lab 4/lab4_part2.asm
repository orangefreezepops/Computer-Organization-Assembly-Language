.data
cities: .asciiz "austin", "miami", "new york", "portland"
prompt: .asciiz "Enter the first letter of a city: "
not_found: .asciiz "city not found"
newline: .asciiz "\n"

# What is the ascii for austin?
# a    u     s     t     i     n     NULL
# 97   117   115   116   105   110   0
# 0x61 0x75  0x73  0x74  0x69  0x6e  0x00         

# How is this stored in memory?
# 0x74737561    0x6d006e69

.text

# TODO: print the prompt
la $a0, prompt
li $v0, 4
syscall

# read a character from the user
li $v0, 12
syscall

# store the user's character in $s1
add $s1, $v0, $0

# TODO: store the base address of cities in $s0
la $s0, cities

# initialize a loop counter
addi $t0, $t0, 4

LOOP:
	# TODO: Use the loop to iterate over the values in
	# the cities array. During each iteration, do the
	# following:
	
	# 1. get the first character of the current city
	lb $t1, 0($s0)
	
	#store $t0 on the stack
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	add $a0, $s0, $0
	#2. compare the character to the user's character
	#	(a) if the chars are the same, jump to FOUND
	beq $s1, $t1, FOUND
	#3. if you reach the end of the array (i.e. your
	#	counter goes to 0), then jump to NOT_FOUND
	beq $t0, $zero, NOT_FOUND
	#4. if you are not at the end of the array, then
	#	call the GET_NEXT_STR procedure, decrement the counter, and continue
	jal GET_NEXT_STR
	
	#restore $t0
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	add $s0, $v0, $0
	
	addi $t0, $t0, -1
	j LOOP


FOUND:
	# print a newline
	li $v0, 4
	la $a0, newline
	syscall

	# print the city name
	li $v0, 4
	add $a0, $s0, $0
	syscall
	
	j EXIT

NOT_FOUND:
	# print a newline
	li $v0, 4
	la $a0, newline
	syscall

	# print "city not found"
	li $v0, 4
	la $a0, not_found
	syscall

EXIT:

# terminate the program
li $v0, 10
syscall


GET_NEXT_STR:
	add $t0, $a0, $0
	
NEXT_STR_LOOP:
	lb $t1, 0($t0)
	beq $t1, $0, EXIT_NEXT_STR_LOOP
	
	# move to the next character
	addi $t0, $t0, 1
	
	j NEXT_STR_LOOP
	
	
EXIT_NEXT_STR_LOOP:

	# move $t1 to the beginning of the next city
	addi $t0, $t0, 1
	
	# return the address of the next city
	add $v0, $t0, $0
	
	jr $ra




