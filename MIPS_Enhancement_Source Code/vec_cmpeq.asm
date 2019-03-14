#***********************************************************************************
# File name: 		vec_cmpeq.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_cmpeq d, a, b' into MIPS architecture. D, A, and B are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction checks if the element of A equals B's, and if so, saves 0xFF into D's corresponding element. If not, remains 0x0. This repeats for all eight elements.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#  		   	$t4 - contains vector A's two bytes that are being compared
#  		  	$t5 - contains vector B's two bytes that are being compared
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x5AFB6C1D		# load the lower half of vector A into t0
	li		$t1, 0xA65FC040		# load the upper half of vector A into t1
	li		$t2, 0x52FBA415		# load the lower half of vector B into t2
	li		$t3, 0xAE5FC841		# load the upper half of vector B into t3	

#	Upper half of the vectors
	srl		$t4, $t0, 24		# shift t4 and t5 right to gain their first elements
	srl 		$t5, $t2, 24
	jal		EquHi			# jump to subroutine to check if A equals B
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next sum
	
	sll		$t4, $t0, 8		# shift t4 and t5 left then right to gain their second elements
	sll		$t5, $t2, 8			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	jal		EquHi			# jump to subroutine to check if A is equals B
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next sum
		
	sll		$t4, $t0, 16		# shift t4 and t5 left then right to gain their third elements
	sll		$t5, $t2, 16			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	jal		EquHi			# jump to subroutine to check if A is equals B
	sll		$s0, $s0, 8		# shift the bytes twice to make room for the next sum
		
	sll		$t4, $t0, 24		# shift t4 and t5 left then right to gain their fourth elements
	sll		$t5, $t2, 24			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	jal		EquHi			# jump to subroutine to check if A is equals B
		 
# 	Lower half of the vectors
	srl		$t4, $t1, 24		# shift t4 and t5 right to gain their fifth elements
	srl 		$t5, $t3, 24
	jal		EquLo			# jump to subroutine to check if A is equals B
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next sum
	
	sll		$t4, $t1, 8		# shift t4 and t5 left then right to gain their sixth elements
	sll		$t5, $t3, 8			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	jal		EquLo			# jump to subroutine to check if A is equals B
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next sum
	
	
	sll		$t4, $t1, 16		# shift t4 and t5 left then right to gain their seventh elements
	sll		$t5, $t3, 16			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	jal		EquLo			# jump to subroutine to check if A is equals B
	sll		$s1, $s1, 8		# shift the bytes twice to make room for the next sum
	
	
	sll		$t4, $t1, 24		# shift t4 and t5 left then right to gain their eighth elements
	sll		$t5, $t3, 24			
	srl		$t4, $t4, 24			
	srl 		$t5, $t5, 24
	jal		EquLo			# jump to subroutine to check if A is equals B	
	
#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine to check for overflow
EquHi:	bne		$t4, $t5, EndH		# exits subroutine if A != B
	addi		$s0, $s0, 0xFF		# sets D's element to 0xFF if A = B
EndH:	jr		$ra			# return to main routine
	
EquLo:	bne		$t4, $t5, EndL		# exits subroutine if A != B
	addi		$s1, $s1, 0xFF		# sets D's element to 0xFF if A = B
EndL:	jr		$ra			# return to main routine

