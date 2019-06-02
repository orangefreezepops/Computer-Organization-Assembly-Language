.eqv cofprice 1
.eqv espprice 2
.eqv latprice 3
.eqv mufprice 2

.macro print %reg
	la $a0, %reg
	li $v0, 4
	syscall
.end_macro

.macro read %reg
	li $v0, 5
	syscall
.end_macro

.macro multiply %prod %num1 %num2
	mult %num1 %num2
	mflo %prod
.end_macro 

.data
menu: .asciiz "Coffee Shop Menu\n" 
cof: .asciiz "1. Coffee $1\n"
esp: .asciiz "2. Espresso $2\n"
lat: .asciiz "3. Latte $3\n"
muf: .asciiz "4. Muffin $2\n"
newl: .asciiz "\n"
order: .asciiz "What item number would you like to order?(1-4) "
quant: .asciiz "And how many would you like?(less than 100) "
summary: .asciiz "Ok, so that'll be $"
nextItem: .asciiz "Would you like to order another item? (1-yes, 0-no)"
farewell: .asciiz "Thank you, have a nice day!"
input1: .space 3
input2: .space 2

.text
INITIAL_LOOP:
	print menu
	print newl
	print cof
	print esp
	print lat
	print muf
	print newl
	print order

#putting the number 4 into a register because menu item 4 (muffin)
#breaks the mold of menu items costing their number positions
#putting price of muffin into $t4
#....will make use of later 
	addi $t3, $0, 4
	addi $t4, $0, 2
#initializing the input string to $s0 and the quantity char into $s1
	la $s0, input1
	la $s1, input2

#read the users order input and store it into input
	read input1
#store the order number into register $t0
	addi $t0, $v0, 0

QUANTITY_LOOP:	
	beq $t0, $t3, MUFFIN

	print quant
	#read the users quantity input
	read input2
	#store the input into register $t1
	addi $t1, $v0, 0
	multiply $t2 $t0 $t1

ORDER_SUMMARY:
	print summary
#call to print an integer
	li $v0, 1
#load the contents of $t2 into $a0 to print
	la $a0, ($t2)
	syscall
	j FINISH_LOOP

MUFFIN:
	print quant
	read input2
	addi $t1, $v0, 0
	multiply $t2, $t1, $t4
	j ORDER_SUMMARY 

FINISH_LOOP:
	print newl
	print nextItem
	read input1
	#add the input to register $t5
	addi $t5, $v0, 0
	beq $t5, $0, END_PROG
		j INITIAL_LOOP

END_PROG:
	print farewell
	