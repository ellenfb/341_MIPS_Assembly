#***********************************************************************************
# File name: 		vec_or.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_or d, a, b' into MIPS architecture. D, A, and B are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction or's each element from A and B one at a time and stores it into the corresponding element in vector D.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#  		   	$t4 - contains vector A's two bytes that are being or'd, then receives the result to be stored into vector D. Set to 0xff if the result causes overflow
#  		  	$t5 - contains vector B's two bytes that are being or'd
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x233C475D		# load the upper half of vector A into t0
	li		$t1, 0x087F196F		# load the lower half of vector A into t1
	li		$t2, 0x981963C5		# load the upper half of vector B into t2
	li		$t3, 0x5E80B36E		# load the lower half of vector B into t3	

#	Upper half of the vectors
	srl		$t4, $t0, 24		# shift t4 and t5 right to gain their first elements
	srl 		$t5, $t2, 24
	or 		$t4, $t4, $t5		# or elements and store the result in t4
	add 		$s0, $t4, $zero		# store result into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next result
		
	sll		$t4, $t0, 8		# shift t4 and t5 left then right to gain their second elements
	sll		$t5, $t2, 8			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	or 		$t4, $t4, $t5		# or elements and store the result in t4
	add 		$s0, $s0, $t4		# store result into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next result
		
	sll		$t4, $t0, 16		# shift t4 and t5 left then right to gain their third elements
	sll		$t5, $t2, 16			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	or 		$t4, $t4, $t5		# or elements and store the result in t4
	add 		$s0, $s0, $t4		# store result into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next result
		
	sll		$t4, $t0, 24		# shift t4 and t5 left then right to gain their fourth elements
	sll		$t5, $t2, 24			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	or 		$t4, $t4, $t5		# or elements and store the result in t4
	add 		$s0, $s0, $t4		# store result into s0, the destination vector D
		 
# 	Lower half of the vectors
	srl		$t4, $t1, 24		# shift t4 and t5 right to gain their fifth elements
	srl 		$t5, $t3, 24
	or 		$t4, $t4, $t5		# or elements and store the result in t4
	add 		$s1, $t4, $zero		# store result into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next result
		
	sll		$t4, $t1, 8		# shift t4 and t5 left then right to gain their sixth elements
	sll		$t5, $t3, 8			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	or 		$t4, $t4, $t5		# or elements and store the result in t4
	add 		$s1, $s1, $t4		# store result into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next result
		
	sll		$t4, $t1, 16		# shift t4 and t5 left then right to gain their seventh elements
	sll		$t5, $t3, 16			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	or 		$t4, $t4, $t5		# or elements and store the result in t4
	add 		$s1, $s1, $t4		# store result into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next result
		
	sll		$t4, $t1, 24		# shift t4 and t5 left then right to gain their eighth elements
	sll		$t5, $t3, 24			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	or 		$t4, $t4, $t5		# or elements and store the result in t4
	add 		$s1, $s1, $t4		# store result into s1, the destination vector D

#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

