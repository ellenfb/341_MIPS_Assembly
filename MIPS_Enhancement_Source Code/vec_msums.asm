#***********************************************************************************
# File name: 		vec_msums.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_msums d, a, b, c' into MIPS architecture. A, B, and C are 8-byte vectors with 2-byte wide elements, and D has 4-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction multiplies the first and second elements from A and B then adds them together with the element in C, then stores it into the corresponding element in vector D.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#  		   	$t4 - contains the lower half of vector C
#			$t5 - contains the upper half of vector C
#			$t6 - contains vector A's two bytes that are being multiplied, handling the even-numbered element positions. It holds the final sum of the operation and stores into vector D
#  		  	$t7 - contains vector B's two bytes that are being multiplied, handling the even-numbered element positions. It also holds vector C's even-numbered elements
#			$t8 - contains vector A's two bytes that are being multiplied, handling the odd-numbered element positions
#			$t9 - contains vector B's two bytes that are being multiplied, handling the odd-numbered element positions
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#			$a0 - set to 0 if there is a sum overflow
#			$a1 - # set to 0xFFFF to check for overflows
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x230CF14D		# load the lower half of vector A into t0
	li		$t1, 0x5C7F191A		# load the upper half of vector A into t1
	li		$t2, 0xA30C5BFD		# load the lower half of vector B into t2
	li		$t3, 0xC5FFC9EE		# load the upper half of vector B into t3
	li		$t4, 0x609E19F7		# load the lower half of vector C into t8
	li		$t5, 0x45670766		# load the upper half of vector C into t9
	li		$a1, 0xFFFF		# set a1 to 0xFFFF

#	Upper half of the vectors
	srl		$t6, $t0, 24		# shift t6 and t7 right to gain their first elements
	srl 		$t7, $t2, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	
	sll		$t8, $t0, 8		# shift t8 and t9 left then right to gain their second elements
	sll		$t9, $t2, 8			
	srl		$t8, $t8, 24			
	srl 		$t9, $t9, 24
	mult 		$t8, $t9		# add elements and store the result in t8
	mflo		$t8			# store the result into t8
	
	add		$t6, $t6, $t8		# add the two products
	srl		$t7, $t4, 16		# shift t7 to gain C's first element
	add		$t6, $t6, $t7		# add the sum of the products to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s0, $s0, $t6		# store sum into s0, the destination vector D
	sll		$s0, $s0, 16		# shift the bytes four times to make room for the next sum
		
	sll		$t6, $t0, 16		# shift t6 and t7 left then right to gain their third elements
	sll		$t7, $t2, 16			
	srl		$t6, $t6, 24
	srl 		$t7, $t7, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	
	sll		$t8, $t0, 24		# shift t8 and t9 left then right to gain their fourth elements
	sll		$t9, $t2, 24		
	srl		$t8, $t8, 24			
	srl 		$t9, $t9, 24
	mult 		$t8, $t9		# add elements and store the result in t8
	mflo		$t8			# store the result into t8
	
	add		$t6, $t6, $t8		# add the two products
	sll		$t7, $t4, 16		# shift t7 left then right to gain C's second element
	srl		$t7, $t7, 16		
	add		$t6, $t6, $t7		# add the sum of the products to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s0, $s0, $t6		# store sum into s0, the destination vector D
			 
# 	Lower half of the vectors
	srl		$t6, $t1, 24		# shift t6 and t7 right to gain their fifth elements
	srl 		$t7, $t3, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	
	sll		$t8, $t1, 8		# shift t8 and t9 left then right to gain their sixth elements
	sll		$t9, $t3, 8			
	srl		$t8, $t8, 24			
	srl 		$t9, $t9, 24
	mult 		$t8, $t9		# add elements and store the result in t8
	mflo		$t8			# store the result into t8
	
	add		$t6, $t6, $t8		# add the two products
	srl		$t7, $t5, 16		# shift t7 to gain C's second element
	add		$t6, $t6, $t7		# add the sum of the products to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s1, $s1, $t6		# store sum into s1, the destination vector D
	sll		$s1, $s1, 16		# shift the bytes four times to make room for the next sum
		
	sll		$t6, $t1, 16		# shift t6 and t7 left then right to gain their seventh elements
	sll		$t7, $t3, 16			
	srl		$t6, $t6, 24
	srl 		$t7, $t7, 24
	mult 		$t6, $t7		# multiply elements
	mflo		$t6			# store the result into t6
	
	sll		$t8, $t1, 24		# shift t8 and t9 left then right to gain their eighth elements
	sll		$t9, $t3, 24		
	srl		$t8, $t8, 24			
	srl 		$t9, $t9, 24
	mult 		$t8, $t9		# add elements and store the result in t8
	mflo		$t8			# store the result into t8
	
	add		$t6, $t6, $t8		# add the two products
	sll		$t7, $t5, 16		# shift t7 left then right to gain C's fourth element
	srl		$t7, $t7, 16		
	add		$t6, $t6, $t7		# add the sum of the products to t7
	jal		Check			# jump to subroutine to check for overflow
	add		$s1, $s1, $t6		# store sum into s1, the destination vector D

#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine to check for overflow
Check:	slt  		$a0, $t6, $a1		# check if t6 is greater than 0xFFFF causing overflow
	bne		$a0, $zero, End		# exits subroutine if not	
	add		$t6, $zero, $a1		# sets $t6 to 0xFFFF is there's overflow
End:	jr		$ra			# return to main routine

