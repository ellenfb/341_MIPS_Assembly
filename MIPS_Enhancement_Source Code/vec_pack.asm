#***********************************************************************************
# File name: 		vec_pack.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_pack d, a, b' into MIPS architecture. D, A, and B are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction combines the elements of A and B such that each element of D is a truncation of the lower half of two consecutive elements in A, with the lower half of D taken from B. The first two elements of A are combined and placed into D's first element, the next two into D's second element, and so on. D's fifth element is when it begins using B's elements.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#  		   	$t4 - contains the lower bit of vector A's even-numbered elements, then receives the sum with the next element's bit and stored into vector D. This is repeated for B.
#  		  	$t5 - contains the lower bit of vector A's odd-numbered elements. This is repeated for B.
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x5AFB6C1D		# load the lower half of vector A into t0
	li		$t1, 0xAE5FC041		# load the upper half of vector A into t1
	li		$t2, 0x52F3A415		# load the lower half of vector B into t2
	li		$t3, 0xA657C849		# load the upper half of vector B into t3	

#	Vector A being packed
	sll		$t4, $t0, 4		# shift t4 and t5 left and right to gain the lower half of the first and second elements of A
	sll		$t5, $t0, 12
	srl		$t4, $t4, 28		
	sll		$t4, $t4, 4
	srl 		$t5, $t5, 28
	add 		$t4, $t4, $t5		# add elements and store the result in t4
	add 		$s0, $s0, $t4		# store sum into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next sum
	
	sll		$t4, $t0, 20		# shift t4 and t5 left and right to gain the lower half of the third and fourth elements of A
	sll		$t5, $t0, 28
	srl		$t4, $t4, 28		
	sll		$t4, $t4, 4
	srl 		$t5, $t5, 28
	add 		$t4, $t4, $t5		# add elements and store the result in t4
	add 		$s0, $s0, $t4		# store sum into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next sum
	
	sll		$t4, $t1, 4		# shift t4 and t5 left and right to gain the lower half of the fifth and sixth elements of A
	sll		$t5, $t1, 12
	srl		$t4, $t4, 28		
	sll		$t4, $t4, 4
	srl 		$t5, $t5, 28
	add 		$t4, $t4, $t5		# add elements and store the result in t4
	add 		$s0, $s0, $t4		# store sum into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next sum
	
	sll		$t4, $t1, 20		# shift t4 and t5 left and right to gain the lower half of the seventh and eighth elements of A
	sll		$t5, $t1, 28
	srl		$t4, $t4, 28		
	sll		$t4, $t4, 4
	srl 		$t5, $t5, 28
	add 		$t4, $t4, $t5		# add elements and store the result in t4
	add 		$s0, $s0, $t4		# store sum into s0, the destination vector D
	
# 	Vector B being packed
	sll		$t4, $t2, 4		# shift t4 and t5 left and right to gain the lower half of the first and second elements of B
	sll		$t5, $t2, 12
	srl		$t4, $t4, 28		
	sll		$t4, $t4, 4
	srl 		$t5, $t5, 28
	add 		$t4, $t4, $t5		# add elements and store the result in t4
	add 		$s1, $s1, $t4		# store sum into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next sum
	
	sll		$t4, $t2, 20		# shift t4 and t5 left and right to gain the lower half of the third and fourth elements of B
	sll		$t5, $t2, 28
	srl		$t4, $t4, 28		
	sll		$t4, $t4, 4
	srl 		$t5, $t5, 28
	add 		$t4, $t4, $t5		# add elements and store the result in t4
	add 		$s1, $s1, $t4		# store sum into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next sum
	
	sll		$t4, $t3, 4		# shift t4 and t5 left and right to gain the lower half of the fifth and sixth elements of B
	sll		$t5, $t3, 12
	srl		$t4, $t4, 28		
	sll		$t4, $t4, 4
	srl 		$t5, $t5, 28
	add 		$t4, $t4, $t5		# add elements and store the result in t4
	add 		$s1, $s1, $t4		# store sum into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next sum
	
	sll		$t4, $t3, 20		# shift t4 and t5 left and right to gain the lower half of the seventh and eighth elements of B
	sll		$t5, $t3, 28
	srl		$t4, $t4, 28		
	sll		$t4, $t4, 4
	srl 		$t5, $t5, 28
	add 		$t4, $t4, $t5		# add elements and store the result in t4
	add 		$s1, $s1, $t4		# store sum into s1, the destination vector D

#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	
