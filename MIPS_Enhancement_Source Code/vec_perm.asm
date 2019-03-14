#***********************************************************************************
# File name: 		vec_perm.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_perm d, a, b, c' into MIPS architecture. D, A, B, and C are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction reads vector C's elements one by one. The upper half decides whether to use vector A or vector B, and the lower half decides which element in the vector to use. The selected element is stored into D's element that corresponds with C's element, and is repeated for all eight.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#  		   	$t4 - contains the upper half of vector C
#			$t5 - contains the lower half of vector C
#			$t6 - contains the element from C to be used in the permutation
#			$t9 - contains the constant 0x4
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#			$a0 - contains the element specifier from C, then the element selected from vector A or B and stores into D
#			$a1 - contains the position of the selected element and acts as a loop counter
#			$a2 - acts as a loop counter incremented by 1 each iteration
#			$a3 - contains 0 or 1, specifying if the element is to be stored into D's upper or lower half
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0xA567013D		# load the upper half of vector A into t0
	li		$t1, 0xAB45393C		# load the lower half of vector A into t1
	li		$t2, 0xEFC54D23		# load the upper half of vector B into t2
	li		$t3, 0x1277AACD		# load the lower half of vector B into t3
	li		$t4, 0x04171002		# load the upper half of vector C into t4
	li		$t5, 0x13050105		# load the lower half of vector C into t5	
	li		$t9, 0x4		# sets t9 to constant 0x4

	srl		$t6, $t4, 24		# sets t6 to C's first element
	jal		Perm
	sll		$s0, $s0, 8		# shifts s0 left two bits to make room for the next element
	
	sll		$t6, $t4, 8		# sets t6 to C's second element
	srl		$t6, $t6, 24
	jal		Perm
	sll		$s0, $s0, 8		# shifts s0 left two bits to make room for the next element
	
	sll		$t6, $t4, 16		# sets t6 to C's third element
	srl		$t6, $t6, 24
	jal		Perm
	sll		$s0, $s0, 8		# shifts s0 left two bits to make room for the next element
	
	sll		$t6, $t4, 24		# sets t6 to C's fourth element
	srl		$t6, $t6, 24
	jal		Perm
	addi		$a3, $a3, 0x1
	
	srl		$t6, $t5, 24		# sets t6 to C's fifth element
	jal		Perm
	sll		$s1, $s1, 8		# shifts s1 left two bits to make room for the next element
	
	sll		$t6, $t5, 8		# sets t6 to C's sixth element
	srl		$t6, $t6, 24
	jal		Perm
	sll		$s1, $s1, 8		# shifts s1 left two bits to make room for the next element
	
	sll		$t6, $t5, 16		# sets t6 to C's seventh element
	srl		$t6, $t6, 24
	jal		Perm
	sll		$s1, $s1, 8		# shifts s1 left two bits to make room for the next element
	
	sll		$t6, $t5, 24		# sets t6 to C's eigth element
	srl		$t6, $t6, 24
	jal		Perm
	
#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine implementing permutation
Perm:	srl		$a0, $t6, 4		# sets a0 to the element specifier
	sll		$a1, $t6, 28		# sets a1 to the position of the element + 1
	srl		$a1, $a1, 28
	addi		$a1, $a1, 0x1
	bne		$a0, $zero, VecB	# branches to VecB if specifier = 1

VecA:	slti		$a0, $a1, 0x5		# branches to UpA if position is in the first half of vector A
	bne		$a0, $zero, UpA
	add		$a0, $t1, $zero		# sets a0 to the lower half of vector A
	subi		$a1, $a1, 0x4		# subtracts 4 from the position to act as a loop counter
	j		P1			# jumps to the first segment of permutation instructions
UpA:	add		$a0, $t0, $zero		# sets a0 to the upper half of vector A

P1:	addi		$a2, $a2, 0x1		# increments a2 by 1 every loop
	beq		$a1, $a2, P2		# branches to second segment when a2 = a1, the element position
	sll		$a0, $a0, 8		# shifts vector A left until the selected element is in the most significant bits
	j		P1
	
P2:	addi		$a1, $zero, 0x3		# sets a1 to 3 to act as a loop counter
	add		$a2, $zero, $zero	# resets a2's loop counter
	
P3:	srl		$a0, $a0, 8		# shifts a0 right until the selected element is in the least significant bits
	addi		$a2, $a2, 0x1		# increments a2 by 1 every loop
	bne		$a1, $a2, P3		# branches to start of segment when a2 != a1, the element position
	add		$a2, $zero, $zero	# sets a2 to zero
	
	bne		$a3, $zero, P4		# branches to fourth segment if a4 != zero
	add		$s0, $s0, $a0		# adds the element to vector D's upper half
	j		ExitA
P4:	add		$s1, $s1, $a0		# adds the element to vector D's lower half

ExitA:	jr		$ra			# jumps back to main section

VecB:   slti		$a0, $a1, 0x5		# branches to UpA if position is in the first half of vector B
	bne		$a0, $zero, UpB
	add		$a0, $t3, $zero		# sets a0 to the lower half of vector B
	subi		$a1, $a1, 0x4		# subtracts 4 from the position to act as a loop counter
	j		P1			# jumps to the first segment of permutation instructions
UpB:	add		$a0, $t2, $zero		# sets a0 to the upper half of vector B
	j		P1