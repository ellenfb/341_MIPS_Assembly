#***********************************************************************************
# File name: 		vec_encry.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_encry d, a, b' into MIPS architecture. A and B are 8-byte vectors; A has two-byte wide elements and B has four-byte wide elements. D is a 16-byte vector with four-byte wide elements. The upper and lower halves of A and B are split between two registers, and D quartered between four. The instruction encrypts each element from A using RSA encryption algorithm. The algorithm's p, q, e, and d values are supplied by each of B's elements. The encrypted elements of A are stored into D's elements one at a time.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B, p in the upper element and q in the lower
#		  	$t3 - contains the lower half of vector B, e in the upper element and d in the lower
#  		   	$t4 - contains n which is found by p * q
#			$t5 - contains e
#		  	$t6 - contains the element from A to be encrypted, then stores into D after encryption
#			$s0 - contains the first quarter of vector D
#		   	$s1 - contains the second quarter  of vector D
#			$s2 - contains the third quarter of vector D
#		   	$s3 - contains the fourth quarter of vector D
#			$a0 - acts as a loop counter, ending the RSA algorithm when equaling e
#			$a1 - used to calculate the encrypted value in the RSA algorithm
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x5D23473C		# load the upper half of vector A into t0
	li		$t1, 0x087F196F		# load the lower half of vector A into t1	
	li		$t2, 0x003D0035		# load the upper half of vector B into t2
	li		$t3, 0x0011019D		# load the lower half of vector B into t2
	
	srl		$t4, $t2, 16		# shift t4 and t5 left and right to set them to p and q
	sll		$t5, $t2, 16
	srl		$t5, $t5, 16
	mult		$t4, $t5		# calculate and store n into t4
	mflo		$t4
	srl		$t5, $t3, 16		# store e into t5
	
#	A's upper half
	srl		$t6, $t0, 24		# set t6 to the first element
	jal		Encry			# call the encryption subroutine
	add		$s0, $s0, $t6		# store the encrypted element into D's first element
	sll		$s0, $s0, 16		# shift the element to make room for the next one
	
	sll		$t6, $t0, 8		# set t6 to the second element
	srl		$t6, $t6, 24		
	jal		Encry			# call the encryption subroutine
	add		$s0, $s0, $t6		# store the encrypted element into D's second element
	
	sll		$t6, $t0, 16		# set t6 to the third element
	srl		$t6, $t6, 24		
	jal		Encry			# call the encryption subroutine
	add		$s1, $s1, $t6		# store the encrypted element into D's third element
	sll		$s1, $s1, 16		# shift the element to make room for the next one
	
	sll		$t6, $t0, 24		# set t6 to the fourth element
	srl		$t6, $t6, 24		
	jal		Encry			# call the encryption subroutine
	add		$s1, $s1, $t6		# store the encrypted element into D's fourth element
	
#	A's lower half
	srl		$t6, $t1, 24		# set t6 to the first element
	jal		Encry			# call the encryption subroutine
	add		$s2, $s2, $t6		# store the encrypted element into D's first element
	sll		$s2, $s2, 16		# shift the element to make room for the next one
	
	sll		$t6, $t1, 8		# set t6 to the second element
	srl		$t6, $t6, 24		
	jal		Encry			# call the encryption subroutine
	add		$s2, $s2, $t6		# store the encrypted element into D's second element
	
	sll		$t6, $t1, 16		# set t6 to the third element
	srl		$t6, $t6, 24		
	jal		Encry			# call the encryption subroutine
	add		$s3, $s3, $t6		# store the encrypted element into D's third element
	sll		$s3, $s3, 16		# shift the element to make room for the next one
	
	sll		$t6, $t1, 24		# set t6 to the fourth element
	srl		$t6, $t6, 24		
	jal		Encry			# call the encryption subroutine
	add		$s3, $s3, $t6		# store the encrypted element into D's fourth element
	
#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine implementing RSA encryption
Encry:	add		$a0, $zero, $zero	# resets a0 to zero
	addi		$a1, $zero, 0x1		# resets a1 to 1
	
Loop:	addi		$a0, $a0, 0x1		# increments the loop counter, a0
	mult		$a1, $t6		# multiplies a1 by the value being encrypted and stores into a1
	mflo		$a1
	div		$a1, $t4		# divides a1 by n and stores into a1
	mfhi		$a1		
	bne		$a0, $t5, Loop		# branches if a0 = t5, e
	add		$t6, $a1, $zero		# sets t6 to a1, the encrypted value
	jr		$ra			# returns to main routine