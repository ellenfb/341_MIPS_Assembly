#***********************************************************************************
# File name: 		vec_mergeh.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_mergeh d, a, b' into MIPS architecture. D, A, and B are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction places the first halves of vectors A and B into vector D alternating. A0 => D0, B0 = > D1, A1 => D2 and so on.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#  		   	$t4 - contains vector A's element that's being placed into D
#  		  	$t5 - contains vector B's element that's being placed into D
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x5AF0A501		# load the lower half of vector A into t0
	li		$t1, 0xAB0155C3		# load the upper half of vector A into t1
	li		$t2, 0xA50F5A23		# load the lower half of vector B into t2
	li		$t3, 0xCD23AA3C		# load the upper half of vector B into t3	

#	Upper half of vector D
	srl		$t4, $t0, 24		# shift t4 and t5 right to gain their first elements
	srl 		$t5, $t2, 24
	add		$s0, $s0, $t4		# adds vector A's element to vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next element
	add		$s0, $s0, $t5		# adds vector B's element to vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next element
		
	sll		$t4, $t0, 8		# shift t4 and t5 left then right to gain their second elements
	sll		$t5, $t2, 8			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	add		$s0, $s0, $t4		# adds vector A's element to vector D
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next element
	add		$s0, $s0, $t5		# adds vector B's element to vector D
		
#	Lower half of vector D
	sll		$t4, $t0, 16		# shift t4 and t5 left then right to gain their third elements
	sll		$t5, $t2, 16			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	add		$s1, $s1, $t4		# adds vector A's element to vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next element
	add		$s1, $s1, $t5		# adds vector B's element to vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next element
		
	sll		$t4, $t0, 24		# shift t4 and t5 left then right to gain their fourth elements
	sll		$t5, $t2, 24			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	add		$s1, $s1, $t4		# adds vector A's element to vector D
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next element
	add		$s1, $s1, $t5		# adds vector B's element to vector D
		 
#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	
