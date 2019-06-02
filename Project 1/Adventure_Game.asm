#initialize hit points of the characters
.eqv r_hp 55
.eqv p_hp 35
.eqv jc_hp 45
.eqv gob_hp 25
.eqv skel_hp 25
.eqv wiz_hp 40 

#initialize the strength of the characters
.eqv rs 8
.eqv ps 14
.eqv jcs 10
.eqv gobs 4
.eqv skels 3
.eqv wizs 8

#macro for printing
.macro print %reg
	la $a0, %reg
	li $v0, 4
	syscall
.end_macro

#macro for printing integers
.macro print_int %reg
	li $v0, 1
	la $a0,0(%reg)
	syscall
.end_macro 

#macro for reading in characters
.macro read %reg
	li $v0, 5
	syscall
.end_macro

#macro for randomizing attack power
#pseudo code: attack (int (upper-lower), int lower)
.macro attack %reg, %reg1
	la $a1, 0(%reg)
	li $v0, 42
	syscall
	add $a0, $a0, %reg1
	add $t7, $a0, $zero
.end_macro

.macro random 
	la $a1, 4
	li $v0, 42
	syscall
	addi $t7, $a0, 1
.end_macro  

#macro for adding health potion
.macro hp_up %reg
	print choice
	print heal
	print newline
	addi %reg, %reg, 10
	print your
	print health
	print_int %reg
	print newline
.end_macro

#macro for adding strength ring
.macro power_up %reg
	print choice
	print ring
	print newline
	addi %reg, %reg, 5
	print your
	print strength
	print_int %reg
	print newline
.end_macro

#macro for checking the health levels of the user and the enemy 
.macro HP_check_skel %reg %reg1
	bltz %reg, GAME_OVER
	beq %reg, $zero, GAME_OVER
	bltz %reg1, NEXT_SKEL
	beq %reg1, $zero, NEXT_SKEL
.end_macro 

.macro HP_check_gob %reg %reg1
	bltz %reg, GAME_OVER
	beq %reg, $zero, GAME_OVER
	bltz %reg1, NEXT_GOB
	beq %reg1, $zero, NEXT_GOB
.end_macro 

.macro HP_check_wiz %reg %reg1
	bltz %reg, GAME_OVER
	beq %reg, $zero, GAME_OVER
	bltz %reg1, YOU_WON
	beq %reg, $zero, YOU_WON
.end_macro

.data 
rogue: .asciiz "Rogue "
paladin: .asciiz "Paladin "
jackiechan: .asciiz "Jackie Chan "
skeleton: .asciiz "Skeleton "
goblin: .asciiz "Goblin "
wizard: .asciiz "Wizard "
begin: .asciiz "ADVENTURE - START!"
guess: .asciiz "Guess a number between 1 and 5 inclusive"
sorry: .asciiz "Sorry that guess was incorrect"
correct: .asciiz "You guessed right! and effectively casted the spell!"
here: .asciiz "Here are the playable characters:"
newline: .asciiz "\n"
cast: .asciiz "Cast a spell"
battle: .asciiz "attack The Wizard"
choose: .asciiz "Which character would you like to be? "
choice: .asciiz "You chose: "
description: .asciiz "The Evil Wizard must be defeated! He is in the Castle.\nTo get to The Castle you must travel through either:" 
one: .asciiz "1. "
two: .asciiz "2. "
three: .asciiz "3. "
grave: .asciiz "The Graveyard"
forest: .asciiz "The Forest"
path: .asciiz "Which path will you take? "
doyou: .asciiz "Do you want to "
gob_enter: .asciiz "Once you enter The Forest, you encounter 3 Goblins! Time for battle!"
skel_enter: .asciiz "Once you enter The Graveyard, you encounter 5 Skeletons! Time for battle!"
reward: .asciiz "Please choose a reward. \n"
heal: .asciiz "Healing Potion"
ring: .asciiz "Ring of Strength"
asterisk: .asciiz "***"
vs: .asciiz " vs "
attacks: .asciiz " attatcks with ATK = "
hero: .asciiz "The Hero"
health: .asciiz " HP is now "
won: .asciiz " won the battle!"
strength: .asciiz " strength is now "
your: .asciiz "Your"
plus: .asciiz " + "
minus: .asciiz " - "
equal: .asciiz " = "
defeat_skel: .asciiz " defeated Skeleton "
defeat_gob: .asciiz " defeated Goblin "
game_over: .asciiz "Sorry, but you have been defeated..." 
play_again: .asciiz "Would you like to play again?"
finally: .asciiz "You've finally made it to the castle! get ready to battle The Evil Wizard!"
congratulations: .asciiz "Congratulations! you defeated the Evil Wizard "
yes: .asciiz "Yes"
no: .asciiz "No"
input1: .space 2
input2: .space 2
input3: .space 2
input4: .space 2

.text
GAME_START:
	#Printing the opening prompts of the adventure game
	print begin
	print newline
	print here
	print newline
	print one
	print rogue
	print newline
	print two
	print paladin
	print newline
	print three
	print jackiechan
	print newline
	print choose
	
	#placing the empty input choices into the following register 
	la $s0, input1
	
	#initializeng $t5 as a loop counter
	addi $t5,$zero,1
	
	#reading the character choice and then adding it to register $t0
	read input1
	addi $t0, $v0, 0
	
	#looping to find which character the user chose
	beq $t0, $t5, ROGUE_GAMEPLAY
		addi $t5, $t5, 1
		beq $t0, $t5, PALADIN_GAMEPLAY
			addi $t5,$t5, 1
			beq $t0, $t5, JC_GAMEPLAY
			
ROGUE_GAMEPLAY:
	la $s3, r_hp
	la $s4, rs
	la $t3, rogue
	
	#loading upper bound of attack power into $t4
	addi $t4, $zero, 3
	
	#clearing register five bc it was used as a loop counter before
	move $t5, $0
	li $t5, 0
	
	#adding the lower bound to $t5
	addi $t5, $zero, 1
	
	print choice
	print rogue
	j ENTER_VILLAINS
	
PALADIN_GAMEPLAY:
	la $s3, p_hp
	la $s4, ps
	la $t3, paladin
	addi $t4, $zero, 4
	move $t5, $0
	li $t5, 0
	addi $t5, $zero, 3
	print choice
	print paladin
	j ENTER_VILLAINS
	
JC_GAMEPLAY:
	la $s3, jc_hp
	la $s4, jcs
	la $t3, jackiechan
	addi $t4, $zero, 4
	move $t5, $0
	li $t5, 0
	addi $t5, $zero, 2
	print choice
	print jackiechan
	j ENTER_VILLAINS
	
ENTER_VILLAINS:
	#new loop counter $t6
	addi $t6, $zero, 1
	#print battle scenarios
	print newline
	print description
	print newline
	print one
	print grave
	print newline
	print two
	print forest
	print newline
	print path
	
	#loading input 2 into register $s1
	la $s1, input2
	read input2
	#placing contents from the read input into $t8
	addi $t8, $v0,0
	beq $t8, $t6, GRAVE_YARD
		addi $t6, $t6, 1
		beq $t8, $t6, FOREST

GRAVE_YARD:
	print newline
	print choice
	print grave
	print newline
	print skel_enter
	print newline
		
	#loading the skeletons data into registers
	la $s5, skel_hp
	la $s6, skels
	
	#loop counter
	addi $t1, $0, 1
	
	#loop counter reference register to break the loop
	move $t0, $0
	li $t0, 0
	addi $t0, $0, 6
	
	#skeleton lower bound attack damage
	move $t6, $0
	li $t6, 0
	addi $t6, $zero, 1
	
	#upper bound attack damage
	move $t8, $0
	li $t8, 0
	addi $t8, $0, 3

SKELLY_FIGHT:

#making a fight loop that stops when the player has fought 5 villains
beq $t1, $t0, WIZARD_BATTLE
	 		
	#skeleton battle
	print asterisk
	print hero
	print vs
	print skeleton 
	print_int  $t1
	print asterisk
	print newline
	
	#printing the users strength + attack power 
	print hero
	print attacks
	print_int $s4
	print plus
	attack $t4 $t5
	print_int $t7
	print equal
	add $t2, $s4, $t7
	print_int $t2
	print newline
	
	#printing the resulting skeletons health
	print skeleton
	print health
	print_int $s5
	print minus
	print_int $t2
	print equal
	sub $s5, $s5, $t2
	print_int $s5
	print newline
	print newline
	
	#checking the health
	HP_check_skel $s3 $s5
	
	#printing the skeletons attack
	print skeleton
	print attacks
	print_int $s6
	print plus
	attack $t8 $t6
	print_int $t7
	print equal
	add $t3, $s6, $t7
	print_int $t3
	print newline
	
	#printing users health	
	print hero
	print health
	print_int $s3
	print minus
	print_int $t3
	print equal
	sub $s3, $s3, $t3
	print_int $s3
	print newline
	print newline
	#checking the health of the user and the health of the skeleton
	HP_check_skel $s3 $s5
	#if neither player is dead go back through the loop
	j SKELLY_FIGHT
	
NEXT_SKEL:
	print hero
	print defeat_skel
	print_int $t1
	print newline
	print newline
	
	#reload the skeletons data into the registers for a new fully functional skeleton
	la $s5, skel_hp
	la $s6, skels
	
	#add to the loop counter
	addi $t1, $t1, 1
	#go back through loop
	j SKELLY_FIGHT
	
FOREST:
	print choice
	print forest
	print newline
	print gob_enter
	print newline
	
	#reload the goblins data into the registers for a new fully functional goblin
	la $s5, gob_hp
	la $s6, gobs
	
	#loop counter
	addi $t1, $0, 1
	
	#loop counter reference register to break the loop
	move $t0, $0
	li $t0, 0
	addi $t0, $0, 4
	
	#goblin lower bound attack damage
	move $t6, $0
	li $t6, 0
	addi $t6, $zero, 2
	
	#upper bound attack damage
	move $t8, $0
	li $t8, 0
	addi $t8, $0, 4
	
GOB_FIGHT:	
#making a fight loop that stops when the player has fought 3 villains
beq $t1, $t0, WIZARD_BATTLE
	 		
	#goblin battle
	print asterisk
	print hero
	print vs
	print goblin 
	print_int  $t1
	print asterisk
	print newline
	
	#printing the users strength + attack power 
	print hero
	print attacks
	print_int $s4
	print plus
	attack $t4 $t5
	print_int $t7
	print equal
	add $t2, $s4, $t7
	print_int $t2
	print newline
	
	#printing the resulting goblins health
	print goblin
	print health
	print_int $s5
	print minus
	print_int $t2
	print equal
	sub $s5, $s5, $t2
	print_int $s5
	print newline
	print newline
	
	#checking the health
	HP_check_gob $s3 $s5
	
	#printing the goblins attack
	print goblin
	print attacks
	print_int $s6
	print plus
	attack $t8 $t6
	print_int $t7
	print equal
	add $t3, $s6, $t7
	print_int $t3
	print newline
	
	#printing users health	
	print hero
	print health
	print_int $s3
	print minus
	print_int $t3
	print equal
	sub $s3, $s3, $t3
	print_int $s3
	print newline
	print newline
	
	#checking the health of the user and the health of the goblin
	HP_check_gob $s3 $s5
	#if neither player is dead go back through the loop
	j GOB_FIGHT

NEXT_GOB:
	print hero
	print defeat_gob
	print_int $t1
	print newline
	print newline
	
	#reload the goblins data into the registers for a new fully functional goblin
	la $s5, gob_hp
	la $s6, gobs
	
	#add to the loop counter
	addi $t1, $t1, 1
	#go back through loop
	j GOB_FIGHT
	
WIZARD_BATTLE:
	#initializing loop counter
	print hero
	print won
	print newline
	print your
	print health
	print_int $s3
	print newline
	print reward
	print one
	print heal
	print newline
	print two
	print ring
	print newline
	
	#loading the wizards data into registers
	la $s5, wiz_hp
	la $s6, wizs
	
	#wizard lower bound attack damage
	move $t6, $0
	li $t6, 0
	addi $t6, $zero, 4
	
	#upper bound attack damage
	move $t8, $0
	li $t8, 0
	addi $t8, $0, 6
	
	#loading input into register $s2
	la $s2, input3
	read input3
	addi $t1, $v0, 0
	addi $t2, $0, 1
	#pseudo if statements to see if the player wants more health or power
	beq $t1, $t2, HEAL
		addi $t2, $t2, 1
		beq $t1, $t2, POWER
		
HEAL:
	hp_up $s3
	#wizard battle
	print asterisk
	print hero
	print vs
	print wizard
	print asterisk
	print newline
	print finally
	j WIZARD_CONTINUE 
POWER:
	power_up $s4
	#wizard battle
	print asterisk
	print hero
	print vs
	print wizard
	print asterisk
	print newline
	print finally
	j WIZARD_CONTINUE
	
WIZARD_CONTINUE:		
	#asking user if they want to attack or cast a spell
	print newline
	print doyou
	print newline
	print one
	print cast
	print newline
	print two
	print battle
	print newline
	
	#loading input into a register
	la $s1, input1
	read input1
	addi $t0, $0, 1
	addi $t1, $v0, 0
	
	# see if the player wants to attack or cast a spell
	beq $t1, $t0, CAST_SPELL
		addi $t0, $t0, 1
		beq $t1, $t0, WIZ_ATTACK

WIZ_ATTACK:		
	#printing the users strength + attack power 
	print hero
	print attacks
	print_int $s4
	print plus
	attack $t4 $t5
	print_int $t7
	print equal
	add $t2, $s4, $t7
	print_int $t2
	print newline
	
	#printing the resulting wizards health
	print wizard
	print health
	print_int $s5
	print minus
	print_int $t2
	print equal
	sub $s5, $s5, $t2
	print_int $s5
	print newline
	print newline
	
	#checking the health
	HP_check_wiz $s3 $s5
	
	#printing the wizards attack
	print wizard
	print attacks
	print_int $s6
	print plus
	attack $t8 $t6
	print_int $t7
	print equal
	add $t3, $s6, $t7
	print_int $t3
	print newline
	
	#printing users health	
	print hero
	print health
	print_int $s3
	print minus
	print_int $t3
	print equal
	sub $s3, $s3, $t3
	print_int $s3
	print newline
	print newline
	
	#checking the health of the user and the health of the wizard
	HP_check_wiz $s3 $s5
	#if neither player is dead go back through the loop
	j WIZARD_CONTINUE

CAST_SPELL:
	print guess
	print newline
	random 
	la $s2, input2
	read input2
	addi $s2, $v0, 0
	#randomly generated number, user input guess, YOU_WON
	beq $s2, $t7, CORRECT
		#incorrect guess
		print sorry
		#wizards attack
		#loop back to WIZARD_CONTINUE
	print newline 
	print wizard
	print attacks
	print_int $s6
	print plus
	attack $t8 $t6
	print_int $t7
	print equal
	add $t3, $s6, $t7
	print_int $t3
	print newline
	
	#printing users health	
	print hero
	print health
	print_int $s3
	print minus
	print_int $t3
	print equal
	sub $s3, $s3, $t3
	print_int $s3
	print newline
	print newline
	
	#checking the health of the user and the health of the wizard
	HP_check_wiz $s3 $s5
	#if neither player is dead go back through the loop
	j WIZARD_CONTINUE
		
CORRECT:
	addi $s5, $zero, 0
	print correct
	print newline
	print wizard
	print health
	print_int $s5
	print newline
	j YOU_WON
	
GAME_OVER:
	print game_over
	print play_again
	print newline
	print one
	print yes
	print newline
	print two
	print no
	print newline
	
	#adding input 4 to register 
	la $s0, input4
	read input4
	
	#adding answer to $t0
	addi $t0, $v0, 0
	addi $t1, $0, 1
	
	#if user input = 1 restart the game
	#otherwise terminate the program
	beq $t0, $t1, GAME_START
		li $v0, 10
		syscall
		
YOU_WON:
	print congratulations
	print play_again
	print newline
	print one
	print yes
	print newline
	print two
	print no
	print newline
	
	#adding input 4 to register 
	la $s0, input4
	read input4
	
	#adding answer to $t0
	addi $t0, $v0, 0
	addi $t1, $0, 1
	
	#if user input = 1 restart the game
	#otherwise terminate the program
	beq $t0, $t1, GAME_START
		li $v0, 10
		syscall