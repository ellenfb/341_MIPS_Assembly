#***********************************************************************************
# File name: 		vec_madd.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_madd d, a, b, c' into MIPS architecture. D, A, B, and C are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction multiplies the first elements from A and B then adds the product with the element in C, then stores it into the corresponding element in vector D. This is repeated for all eight elements.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#  		   	$t4 - contains the lower half of vector C
#			$t5 - contains the upper half of vector C
#			$t6 - contains vector A's two bytes that are being multiplied. It holds the final sum of the operations and stores into vector D
#  		  	$t7 - contains vector B's two bytes that are being multiplied. It then holds the element in vector C in the latter half of each operation
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#			$a0 - set to 0 if there is a sum overflow
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x120C1A0D		# load the lower half of vector A into t0
	li		$t1, 0x23051912		# load the upper half of vector A into t1
	li		$t2, 0x3D0C104D		# load the lower half of vector B into t2
	li		$t3, 0x057F192B		# load the upper half of vector B into t3
	li		$t4, 0x60091B05		# load the lower half of vector C into t8
	li		$t5, 0x501E0660		# load the upper half of vector C into t9

#	Upper half of the vectors
	srl		$t6, $t0, 24		# shift t6 and t7 right to gain their first elements
	srl 		$t7, $t2, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	srl		$t7, $t4, 24		# shift t7 to gain C's first element
	add		$t6, $t6, $t7		# add the product to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s0, $s0, $t6		# store sum into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes two times to make room for the next sum
	
	sll		$t6, $t0, 8		# shift t6 and t7 left then right to gain their second elements
	sll 		$t7, $t2, 8
	srl		$t6, $t6, 24		
	srl 		$t7, $t7, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	sll		$t7, $t4, 8
	srl		$t7, $t7, 24		# shift t7 to gain C's second element
	add		$t6, $t6, $t7		# add the product to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s0, $s0, $t6		# store sum into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes two times to make room for the next sum
	
	sll		$t6, $t0, 16		# shift t6 and t7 left then right to gain their third elements
	sll 		$t7, $t2, 16
	srl		$t6, $t6, 24		
	srl 		$t7, $t7, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	sll		$t7, $t4, 16
	srl		$t7, $t7, 24		# shift t7 to gain C's third element
	add		$t6, $t6, $t7		# add the product to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s0, $s0, $t6		# store sum into s0, the destination vector D
	sll		$s0, $s0, 8		# shift the bytes two times to make room for the next sum
	
	sll		$t6, $t0, 24		# shift t6 and t7 left then right to gain their fourth elements
	sll 		$t7, $t2, 24
	srl		$t6, $t6, 24		
	srl 		$t7, $t7, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	sll		$t7, $t4, 24
	srl		$t7, $t7, 24		# shift t7 to gain C's fourth element
	add		$t6, $t6, $t7		# add the product to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s0, $s0, $t6		# store sum into s0, the destination vector D
			 
# 	Lower half of the vectors
	srl		$t6, $t1, 24		# shift t6 and t7 right to gain their fifth elements
	srl 		$t7, $t3, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	srl		$t7, $t5, 24		# shift t7 to gain C's fifth element
	add		$t6, $t6, $t7		# add the product to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s1, $s1, $t6		# store sum into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes two times to make room for the next sum
	
	sll		$t6, $t1, 8		# shift t6 and t7 left then right to gain their sixth elements
	sll 		$t7, $t3, 8
	srl		$t6, $t6, 24		
	srl 		$t7, $t7, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	sll		$t7, $t5, 8
	srl		$t7, $t7, 24		# shift t7 to gain C's sixth element
	add		$t6, $t6, $t7		# add the product to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s1, $s1, $t6		# store sum into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes two times to make room for the next sum
	
	sll		$t6, $t1, 16		# shift t6 and t7 left then right to gain their seventh elements
	sll 		$t7, $t3, 16
	srl		$t6, $t6, 24		
	srl 		$t7, $t7, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	sll		$t7, $t5, 16
	srl		$t7, $t7, 24		# shift t7 to gain C's seventh element
	add		$t6, $t6, $t7		# add the product to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s1, $s1, $t6		# store sum into s1, the destination vector D
	sll		$s1, $s1, 8		# shift the bytes two times to make room for the next sum
	
	sll		$t6, $t1, 24		# shift t6 and t7 left then right to gain their eighth elements
	sll 		$t7, $t3, 24
	srl		$t6, $t6, 24		
	srl 		$t7, $t7, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	sll		$t7, $t5, 24
	srl		$t7, $t7, 24		# shift t7 to gain C's eighth element
	add		$t6, $t6, $t7		# add the product to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s1, $s1, $t6		# store sum into s1, the destination vector D

#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine to check for overflow
Check:	slti		$a0, $t6, 0xFF		# check if t6 is greater than 0xFF causing overflow
	bne		$a0, $zero, End		# exits subroutine if not	
	sll		$t6, $t6, 24		# shifts t6 left then right so only the two least significant bits are present if so
	srl		$t6, $t6, 24
End:	jr		$ra			# return to main routine

