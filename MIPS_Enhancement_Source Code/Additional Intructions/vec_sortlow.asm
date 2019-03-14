#***********************************************************************************
# File name: 		vec_sortlow.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_sortlow d, a' into MIPS architecture. D and A are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction sorts the elements in A until the entire vector is in decreasing numerical order. The sorted result is stored in D.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#			$t2 - contains an element of A to be compared with the following element, then swapped if less than
#		  	$t3 - contains an element of A to be compared with the previous element, then swapped if not less than
#  		   	$t4 - contains a portion of s0 or s1 to be subtracted from s0 or s1. The gap is then filled in with t1 and t2, swapped if needing to be sorted
#			$s0 - contains the upper half of vector D
#		   	$s1 - contains the lower half of vector D
#			$a0 - set to 0 if t2 < t3 and needs to be swapped
#		   	$ra - holds the return address
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x5D23473C		# load the upper half of vector A into t0
	li		$t1, 0x087F196F		# load the lower half of vector A into t1	
	
	add		$s0, $t0, $zero		# set s0 to t0, the vector to be sorted
	add		$s1, $t1, $zero		# set s1 to t1, the vector to be sorted

L1:	add		$t9, $zero, $zero	# sets the swap checker back to zero
	srl		$t2, $s0, 24		# shift t2 and t3 left then right to gain the first and second elements		
	sll		$t3, $s0, 8				
	srl		$t3, $t3, 24
	slt		$a0, $t3, $t2		# checks if the element in t2 is greater than t3's, branches to L2 if so
	bne		$a0, $zero, L2
	sll		$s0, $s0, 16		# if not, swaps the elements
	srl		$s0, $s0, 16
	jal		Swap
	sll		$t2, $t2, 24
	sll		$t3, $t3, 16
	add		$s0, $s0, $t2
	add		$s0, $s0, $t3
	
L2:	sll		$t2, $s0, 8		# shift t2 and t3 left then right to gain the second and third elements
	sll		$t3, $s0, 16
	srl		$t2, $t2, 24			
	srl 		$t3, $t3, 24
	slt		$a0, $t3, $t2		# checks if the element in t2 is greater than t3's, branches to L3 if so
	bne		$a0, $zero, L3
	sll		$t4, $s0, 8		# if not, swaps the elements
	srl		$t4, $t4, 16
	sll		$t4, $t4, 8
	sub		$s0, $s0, $t4
	jal		Swap
	sll		$t2, $t2, 16
	sll		$t3, $t3, 8
	add		$s0, $s0, $t2
	add		$s0, $s0, $t3
	
L3:	sll		$t2, $s0, 16		# shift t2 and t3 left then right to gain the third and fourth elements
	sll		$t3, $s0, 24
	srl		$t2, $t2, 24			
	srl 		$t3, $t3, 24
	slt		$a0, $t3, $t2		# checks if the element in t2 is greater than t3's, branches to L4 if so
	bne		$a0, $zero, L4
	srl		$s0, $s0, 16		# if not, swaps the elements
	sll		$s0, $s0, 16
	jal		Swap
	sll		$t2, $t2, 8
	add		$s0, $s0, $t2
	add		$s0, $s0, $t3
	
L4:	sll		$t2, $s0, 24		# shift t2 and t3 left then right to gain the fourth and fifth elements
	srl		$t2, $t2, 24			
	srl 		$t3, $s1, 24
	slt		$a0, $t3, $t2		# checks if the element in t2 is greater than t3's, branches to L5 if so
	bne		$a0, $zero, L5
	srl		$s0, $s0, 8		# if not, swaps the elements
	sll		$s0, $s0, 8
	sll		$s1, $s1, 8
	srl		$s1, $s1, 8
	jal		Swap
	sll		$t3, $t3, 24
	add		$s0, $s0, $t2
	add		$s1, $s1, $t3
	
L5:	srl		$t2, $s1, 24		# shift t2 and t3 left then right to gain the fifth and sixth elements
	sll		$t3, $s1, 8		
	srl		$t3, $t3, 24
	slt		$a0, $t3, $t2		# checks if the element in t2 is greater than t3's, branches to L6 if so
	bne		$a0, $zero, L6
	sll		$s1, $s1, 16		# if not, swaps the elements
	srl		$s1, $s1, 16
	jal		Swap
	sll		$t2, $t2, 24
	sll		$t3, $t3, 16
	add		$s1, $s1, $t2
	add		$s1, $s1, $t3
	
L6:	sll		$t2, $s1, 8		# shift t2 and t3 left then right to gain the sixth and seventh elements
	sll		$t3, $s1, 16
	srl		$t2, $t2, 24			
	srl 		$t3, $t3, 24
	slt		$a0, $t3, $t2		# checks if the element in t2 is greater than t3's, branches to L7 if so
	bne		$a0, $zero, L7
	sll		$t4, $s1, 8		# if not, swaps the elements
	srl		$t4, $t4, 16
	sll		$t4, $t4, 8
	sub		$s1, $s1, $t4
	jal		Swap
	sll		$t2, $t2, 16
	sll		$t3, $t3, 8
	add		$s1, $s1, $t2
	add		$s1, $s1, $t3
	
L7:	sll		$t2, $s1, 16		# shift t2 and t3 left then right to gain the seventh and eigth elements
	sll		$t3, $s1, 24
	srl		$t2, $t2, 24			
	srl 		$t3, $t3, 24
	slt		$a0, $t3, $t2		# checks if the element in t2 is greater than t3's, branches to L4 if so
	bne		$a0, $zero, L8
	srl		$s1, $s1, 16		# if not, swaps the elements
	sll		$s1, $s1, 16
	jal		Swap
	sll		$t2, $t2, 8
	add		$s1, $s1, $t2
	add		$s1, $s1, $t3

L8:	bne		$t9, $zero, L1		# if no swaps have happened the entire sequence, the vector is sorted and instruction ended
	
#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Subroutine implementing the swap
Swap:	add		$a0, $t2, $zero		# swaps the registers the elements are in
	add		$t2, $t3, $zero
	add		$t3, $a0, $zero
	addi		$t9, $zero, 0x1		# t9 is set to 1 if a swap has taken place
	jr		$ra			# returns to main routine