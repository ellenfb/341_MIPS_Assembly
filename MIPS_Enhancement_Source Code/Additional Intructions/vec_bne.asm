#***********************************************************************************
# File name: 		vec_bne.asm
# Version: 		1.0
# Date: 		November 12, 2018
# Programmer: 		Ellen Burger
#
# Description: 		Code implementing the instruction 'vec_beq a, b, imm' into MIPS architecture. A and B are 8-byte vectors with 2-byte wide elements. The upper and lower halves of each vector are split between two registers. The instruction checks if the vectors are inqeual at any element. If so, branches to the address in imm which is represented by "Target" in this example. Moves onto the next instruction as normal if not.
#
# Register useage: 	$t0 - contains the upper half of vector A
#		  	$t1 - contains the lower half of vector A
#		  	$t2 - contains the upper half of vector B
#		  	$t3 - contains the lower half of vector B
#***********************************************************************************

# Main code segment
.text
.globl  main

main:	li		$t0, 0x233C475D		# load the lower half of vector A into t0
	li		$t1, 0x087F196F		# load the upper half of vector A into t1
	li		$t2, 0x233C475D		# load the lower half of vector B into t2
	li		$t3, 0x087F087F		# load the upper half of vector B into t3
	
	bne		$t0, $t2, Target	# checks if the upper halves of A and B aren't equal and branches to Target if so. Continues to check the lower halves if not
	bne		$t1, $t3, Target	# checks if the lower halves of A and B aren't equal and branches to Target if so. Exits if not
	
#	Function code for exit
exit:	ori		$v0, $zero, 10
	syscall	

#	Branch to the immediate value
Target:	j		exit			# Instruction branches to Target if A != B. In this example, Target then exits the instruction

