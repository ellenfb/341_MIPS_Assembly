#***********************************************************************************
# File name: 		vec_decry.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_decry d, a, b' into MIPS architecture. D and B are 8-byte vectors; D has two-byte wide elements and B has four-byte wide elements. A is a 16-byte vector with four-byte wide elements. The upper and lower halves of D and B are split between two registers, and A quartered between four. The instruction decrypts each element from A using RSA decryption algorithm. The algorithm's p, q, e, and d values are supplied by each of B's elements. The decrypted elements of A are stored into D's elements one at a time.
#
# Register useage: 	$t0 - contains the first quarter of vector A
#		  	$t1 - contains the second quarter of vector A
#			$t2 - contains the third quarter of vector A
#		  	$t3 - contains the fourth quarter of vector A
#		  	$t4 - contains the upper half of vector B, p in the upper element and q in the lower
#		  	$t5 - contains the lower half of vector B, e in the upper element and d in the lower
#  		   	$t6 - contains n which is found by p * q
#			$t7 - contains d
#		  	$t8 - contains the element from A to be decrypted, then stores into D after decryption
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#			$a0 - acts as a loop counter, ending the RSA algorithm when equaling d
#			$a1 - used to calculate the decrypted value in the RSA algorithm
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x024d0399		# load the first quarter of vector A into t0
	li		$t1, 0x029d0449		# load the second quarter of vector A into t1	
	li		$t2, 0x07f90932		# load the third quarter of vector A into t2
	li		$t3, 0x08a30889		# load the fourth quarter of vector A into t3
	li		$t4, 0x003D0035		# load the upper half of vector B into t4
	li		$t5, 0x0011019D		# load the lower half of vector B into t5
	
	srl		$t6, $t4, 16		# shift t6 and t7 left and right to set them to p and q
	sll		$t7, $t4, 16
	srl		$t7, $t7, 16
	mult		$t6, $t7		# calculate and store n into t6
	mflo		$t6
	sll		$t7, $t5, 16		# store d into t7
	srl		$t7, $t7, 16
	
#	A's upper half
	srl		$t8, $t0, 16		# set t8 to the first element
	jal		Decry			# call the decryption subroutine
	add		$s0, $s0, $t8		# store the decrypted element into D's first element
	sll		$s0, $s0, 8		# shift the element to make room for the next one
	
	sll		$t8, $t0, 16		# set t8 to the second element
	srl		$t8, $t8, 16		
	jal		Decry			# call the decryption subroutine
	add		$s0, $s0, $t8		# store the decrypted element into D's second element
	sll		$s0, $s0, 8		# shift the element to make room for the next one
	
	srl		$t8, $t1, 16		# set t8 to the third element	
	jal		Decry			# call the decryption subroutine
	add		$s0, $s0, $t8		# store the decrypted element into D's third element
	sll		$s0, $s0, 8		# shift the element to make room for the next one
	
	sll		$t8, $t1, 16		# set t8 to the fourth element
	srl		$t8, $t8, 16		
	jal		Decry			# call the decryption subroutine
	add		$s0, $s0, $t8		# store the decrypted element into D's fourth element
	
#	A's lower half
	srl		$t8, $t2, 16		# set t8 to the first element
	jal		Decry			# call the decryption subroutine
	add		$s1, $s1, $t8		# store the decrypted element into D's first element
	sll		$s1, $s1, 8		# shift the element to make room for the next one
	
	sll		$t8, $t2, 16		# set t8 to the second element
	srl		$t8, $t8, 16		
	jal		Decry			# call the decryption subroutine
	add		$s1, $s1, $t8		# store the decrypted element into D's second element
	sll		$s1, $s1, 8		# shift the element to make room for the next one
	
	srl		$t8, $t3, 16		# set t8 to the third element	
	jal		Decry			# call the decryption subroutine
	add		$s1, $s1, $t8		# store the decrypted element into D's third element
	sll		$s1, $s1, 8		# shift the element to make room for the next one
	
	sll		$t8, $t3, 16		# set t8 to the fourth element
	srl		$t8, $t8, 16		
	jal		Decry			# call the decryption subroutine
	add		$s1, $s1, $t8		# store the decrypted element into D's fourth element
	
#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine implementing RSA decryption
Decry:	add		$a0, $zero, $zero	# resets a0 to zero
	addi		$a1, $zero, 0x1		# resets a1 to 1
	
Loop:	addi		$a0, $a0, 0x1		# increments the loop counter, a0
	mult		$a1, $t8		# multiplies a1 by the value being decrypted and stores into a1
	mflo		$a1
	div		$a1, $t6		# divides a1 by n and stores into a1
	mfhi		$a1		
	bne		$a0, $t7, Loop		# branches if a0 = t7, e
	add		$t8, $a1, $zero		# sets t8 to a1, the decrypted value
	jr		$ra			# returns to main routine