#***********************************************************************************
# File name: 		vec_mulo.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_mulo d, a, b' into MIPS architecture. A, B, and C are 8-byte vectors with 2-byte wide elements, and D has 4-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction multiplies the odd-numbered element positions of A and B and stores the 16-bit product into vector D.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#			$t4 - contains vector A's two bytes that are being multiplied, handling the odd-numbered element positions. It holds the product and stores it into vector D.
#  		  	$t5 - contains vector B's two bytes that are being multiplied, handling the odd-numbered element positions.
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#			$a0 - set to 0 if there is a product overflow
#			$a1 - # set to 0xFFFF to check for overflows
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0xAEE95AE0		# load the lower half of vector A into t0
	li		$t1, 0xF080CC66		# load the upper half of vector A into t1
	li		$t2, 0x33146170		# load the lower half of vector B into t2
	li		$t3, 0x609888AB		# load the upper half of vector B into t3
	li		$a1, 0xFFFF		# set a1 to 0xFFFF

#	Upper half of the vectors
	sll		$t4, $t0, 8		# shift t4 and t5 left then right to gain their second elements
	sll		$t5, $t2, 8
	srl		$t4, $t4, 24
	srl 		$t5, $t5, 24
	mult 		$t4, $t5		# multiply elements
	mflo		$t4			# store the result into t4
	jal		Check			# jump to subroutine to check for overflow
	add		$s0, $s0, $t4		# store product into s0, the destination vector D
	sll		$s0, $s0, 16		# shift the bytes four times to make room for the next sum
		
	sll		$t4, $t0, 24		# shift t4 and t5 left then right to gain their fourth elements
	sll		$t5, $t2, 24			
	srl		$t4, $t4, 24
	srl 		$t5, $t5, 24
	mult 		$t4, $t5		# multiply elements
	mflo		$t4			# store the result into t4
	jal		Check			# jump to subroutine to check for overflow
	add		$s0, $s0, $t4		# store product into s0, the destination vector D
			 
# 	Lower half of the vectors
	sll		$t4, $t1, 8		# shift t4 and t5 left then right to gain their sixth elements
	sll		$t5, $t3, 8
	srl		$t4, $t4, 24
	srl 		$t5, $t5, 24
	mult 		$t4, $t5		# multiply elements
	mflo		$t4			# store the result into t4
	jal		Check			# jump to subroutine to check for overflow
	add		$s1, $s1, $t4		# store product into s1, the destination vector D
	sll		$s1, $s1, 16		# shift the bytes four times to make room for the next sum
		
	sll		$t4, $t1, 24		# shift t4 and t5 left then right to gain their eighth elements
	sll		$t5, $t3, 24			
	srl		$t4, $t4, 24
	srl 		$t5, $t5, 24
	mult 		$t4, $t5		# multiply elements
	mflo		$t4			# store the result into t4
	jal		Check			# jump to subroutine to check for overflow
	add		$s1, $s1, $t4		# store product into s1, the destination vector D

#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine to check for overflow
Check:	slt  		$a0, $t4, $a1		# check if t4 is greater than 0xFFFF causing overflow
	bne		$a0, $zero, End	# exits subroutine if not	
	add		$t4, $zero, $a1		# sets $t4 to 0xFFFF is there's overflow
End:	jr		$ra			# return to main routine

