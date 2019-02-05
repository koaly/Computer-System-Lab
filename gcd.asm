.data
	print_ans:	.asciiz "gcd of 1890 and 3315 is "
	print_newline:	.asciiz "\n"
.text
.globl  main # call main by SPIM 

gcd: # gcd(m, n)
	addi	$sp, $sp, -8 	# allocate 2 bytes for $fp and $ra
	sw	$fp, 0($sp) 	# push $fp to stack
	sw	$ra, 4($sp) 	# push $ra to stack
	move	$fp, $sp	# move frame pointer pointing at stack pointer
	lw	$t0, 8($fp) 	# load 1st argument to $t0 (m)
	lw	$t1, 12($fp)	# load 2nd argument to $t1 (n)
	
	# if(m == n)
	bne	$t0, $t1, if_more 
	lw	$ra, 4($fp)	# load return address
	lw	$fp, 0($fp)	# load previous frame pointer
	addi	$sp, $sp, 8	# pop stack (free 2 bytes of $ra and $fp)
	add	$v0, $t0, $zero	# set return value to $t0 (m)
	jr	$ra		# return function by jump to return address
	
if_more:
	# else if (m > n)
	slt	$t2, $t1, $t0
	beq	$t2, $zero, else
	sub	$t0, $t0, $t1	# m = m - n
	addi	$sp, $sp, -8	# allocate 2 bytes for 2 arguments (m and n)
	sw	$t0, 0($sp)	# push m in $t0 to stack
	sw	$t1, 4($sp)	# push n in $t1 to stack
	jal	gcd		# call gcd(m, n)
	addi	$sp, $sp, 8	# pop stack (free 2 bytes of arguments)
	lw	$ra, 4($fp)	# load return address
	lw	$fp, 0($fp)	# load previous frame pointer
	addi	$sp, $sp, 8	# pop stack (free 2 bytes of $ra and $fp)
	jr	$ra		# return function by jump to return address
	
else:
	# else
	sub	$t1, $t1, $t0	# n = n - m
	addi	$sp, $sp, -8	# allocate 2 bytes for 2 arguments (m and n) 
	sw	$t0, 0($sp)	# push m in $t0 to stack
	sw	$t1, 4($sp)	# push n in $t1 to stack
	jal	gcd		# call gcd(m, n)
	addi	$sp, $sp, 8	# pop stack (free 2 bytes of arguments)
	lw	$ra, 4($fp)	# load return address
	lw	$fp, 0($fp)	# load previous frame pointer
	addi	$sp, $sp, 8	# pop stack (free 2 bytes of $ra and $fp)
	jr	$ra		# return function by jump to return address
	
main:
	#print "gcd of 1890 and 3315 is "
	li	$v0, 4
	la	$a0, print_ans
	syscall
	
	#call gcd(1890, 3315)
	addi	$t0, $t0, 1890 	# m = 1890
	addi 	$t1, $t1, 3315 	# n = 3315
	addi 	$sp, $sp, -8	# allocate 2 bytes for 2 arguments (m and n)
	sw	$t0, 0($sp)	# push m in $t0 to stack
	sw	$t1, 4($sp)	# push n in $t1 to stack
	jal	gcd		# call gcd(m, n)
	addi	$sp, $sp, 8	# pop stack (free 2 bytes of arguments)
	move	$t2, $v0	# move return value in $v0 to $t2
	
	#print gcd(1890, 3315)
	li	$v0, 1
	add	$a0, $t2, $zero
	syscall
	
	#print "\n"
	li	$v0, 4
	la	$a0, print_newline
	syscall
exit:
	li	$v0, 10
	syscall