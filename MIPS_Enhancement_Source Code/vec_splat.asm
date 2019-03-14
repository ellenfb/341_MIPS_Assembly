#***********************************************************************************
# File name: 		vec_splat.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_splat d, a, b' into MIPS architecture. D, A, and B are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction reads vector B and uses its value to select an element from vector A, which is then placed into each element of vector D.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B, the position of vector A to be splatted
#  		   	$t4 - contains the element of vector A being splatted
#			$t5 - used as a loop counter
#			$t6 - used as a loop counter
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#			$a0 - set to 0 if the vector B goes beyond the vector range, then used as part of loop counters
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x230C124D		# load the upper half of vector A into t0
	li		$t1, 0x057F192A		# load the lower half of vector A into t1
	li		$t2, 0x00000000		# load the upper half of vector B into t2
	li		$t3, 0x00000005		# load the lower half of vector B into t3	

	jal		Check			# jump to subroutine to check for range
	addi		$a0, $zero, 0x8		# sets a0 to 0x8 to later calculate how many times a loop must iterate
	slti		$t4, $t3, 0x4		# checks if the value in B is less than four, branches to Hi if not
	addi		$t6, $t3, 0x1		# increments B's value for use in loops
	beq		$t4, $zero, Hi

#	If the vector element is in the lower half of A	
	add		$t4, $t0, $zero		# sets t4 to vector A's lower values
Low1:	sll		$t4, $t4, 4		# shifts t4 left until the selected element is the two most significant bits
	addi		$t5, $t5, 0x1
	bne		$t6, $t5, Low1
	
	sub		$t6, $a0, $t6		# calcuates how many times t4 needs to be shifted right
	add		$t5, $zero, $zero	# resets t5's loop counter
Low2:	srl		$t4, $t4, 4		# shifts t4 right until the selected element is the two least significant bits
	addi		$t5, $t5, 0x1
	bne		$t6, $t5, Low2
	addi		$a0, $zero, 0x4		# sets a0 to 0x4 to act as a loop end amount
	add		$t5, $zero, $zero	# resets t5's loop counter
	j		Splat1			# jumps to the splat section of the instruction
	
#	If the vector element is in the upper half of A	
Hi:	subi		$t6, $t6, 0x4		# calculates how many times t4 needs to be shifted left
	add		$t4, $t1, $zero		# sets t4 to vector A's upper values
Hi1:	sll		$t4, $t4, 4		# shifts t4 left until the selected element is the two most significant bits
	addi		$t5, $t5, 0x1
	bne		$t6, $t5, Hi1
	
	sub		$t6, $a0, $t6		# calcuates how many times t4 needs to be shifted right
	add		$t5, $zero, $zero	# resets t5's loop counter
Hi2:	srl		$t4, $t4, 4		# shifts t4 right until the selected element is the two least significant bits
	addi		$t5, $t5, 0x1
	bne		$t6, $t5, Hi2
	addi		$a0, $zero, 0x4		# sets a0 to 0x4 to act as a loop end amount
	add		$t5, $zero, $zero	# resets t5's loop counter

#	Implementing the splat
Splat1:	sll		$s0, $s0, 8		# shifts s0 left two bits, loops until each element of D is the selected element
	add		$s0, $s0, $t4		# adds the element from A into D's lower half
	addi		$t5, $t5, 0x1
	bne		$a0, $t5, Splat1
	add		$t5, $zero, $zero	# resets t5's loop counter
	
Splat2: sll		$s1, $s1, 8		# shifts s0 left two bits, loops until each element of D is the selected element
	add		$s1, $s1, $t4		# adds the element from A into D's upper half
	addi		$t5, $t5, 0x1
	bne		$a0, $t5, Splat2

#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine to check for overflow
Check:	slti  		$a0, $t6, 0x7		# check if t4 is greater than 0x7 which is beyond the range of the vectors
	bne		$a0, $zero, End		# exits the subroutine if not		
	j		exit			# cancels the instruction if so
End:	jr		$ra			# return to main routine

