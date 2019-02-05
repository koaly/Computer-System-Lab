.data
	psp:	.asciiz " "
	pnl:	.asciiz "\n"
.text

.globl main # call main by SPIM
	
insertionSortRecursive:
	addi	$sp, $sp, -8 	# allocate 8 bytes for $fp and $ra
	sw	$fp, 0($sp) 	# push $fp to stack
	sw	$ra, 4($sp) 	# push $ra to stack
	move	$fp, $sp	# move frame pointer pointing at stack pointer
	lw	$t0, 8($fp) 	# load 1st argument to $t0 (address of data, arr)
	lw	$t1, 12($fp)	# load 2nd argument to $t1 (n)
	
	# if(n <= 1)
	addi	$t2, $zero, 1	# $t2 = 1
	slt	$t2, $t2, $t1	# 1 < n (n > 1) if (n <= 1) then $t2 = 0
	bne	$t2, $zero, call
	lw	$ra, 4($fp)	# load return address
	lw	$fp, 0($fp)	# load previous frame pointer
	addi	$sp, $sp, 8	# pop stack (free 8 bytes of $ra and $fp)
	jr	$ra		# return function by jump to return address
	
call: #call insertionSortRecursive(arr, n-1)
	addi	$t2, $t1, -1	# n-1
	addi 	$sp, $sp, -8	# allocate 8 bytes for 2 arguments (arr and n-1)
	sw	$t0, 0($sp)	# push pointer arr to stack
	sw	$t2, 4($sp)	# push n-1 to stack
	jal	insertionSortRecursive
	addi 	$sp, $sp, 8	# pop (clear) stack
	lw	$t1, 12($fp)	# load 2nd argument again
	addi	$t2, $t1, -1	# n-1
	
	sll	$t3, $t2, 2	# convert n-1 to word offset
	add	$t4, $t0, $t3	# address arr + n-1 => arr[n-1] in $t4
	addi 	$t5, $t2, -1	# j = n-2 (n-1 - 1)
	lw	$t3, 0($t4)	# load arr[n-1] to $t3 (last)
	sll	$t9, $t5, 2	# convert j to word offset
	add	$t4, $t0, $t9	# address arr + j => arr[j] in $t4
	lw	$t8, 0($t4)	# load arr[j] to $t4
loop_compare:
	slt	$t6, $t5, $zero	# j < 0 (check j >= 0)
	xori	$t6, $t6, 1	# j >= 0 is 1
	sll	$t9, $t5, 2	# convert j to word offset
	add	$t4, $t0, $t9	# address arr + j
	lw	$t8, 0($t4)	# load arr[j] to $t4
	slt	$t7, $t3, $t8	# last < arr[j] (check arr[j] > last)
	and	$t6, $t6, $t7	# j >= 0 && arr[j] > last is 1
	beq	$t6, $zero, exit_loop
	sw	$t8, 4($t4)	# arr[j+1] = arr[j]
	addi	$t5, $t5, -1	# j--
	j	loop_compare
exit_loop:
	sw	$t3, 4($t4)	# arr[j+1] = last
	lw	$ra, 4($fp)	# load return address
	lw	$fp, 0($fp)	# load previous frame pointer
	addi	$sp, $sp, 8	# pop stack (free 8 bytes of $ra and $fp)
	jr	$ra		# return function by jump to return address

	
printArray:
	addi	$sp, $sp, -8 	# allocate 8 bytes for $fp and $ra
	sw	$fp, 0($sp) 	# push $fp to stack
	sw	$ra, 4($sp) 	# push $ra to stack
	move	$fp, $sp	# move frame pointer pointing at stack pointer
	lw	$t0, 8($fp) 	# load 1st argument to $t0 (address of data)
	lw	$t1, 12($fp)	# load 2nd argument to $t1 (n)
	addi    $t2, $zero, 0 	# i in $t2 = 0
loop_print:
	sll	$t3, $t2, 2	# convert i to word offset
	add	$t4, $t0, $t3	# address arr + i => arr[i] in $t4 
	lw	$t4, 0($t4)	# load arr[i]
	
	#print arr[i]
	li	$v0, 1
	add	$a0, $t4, $zero
	syscall
	
	#print " "
	li	$v0, 4
	la	$a0, psp
	syscall
	
	addi	$t2, $t2, 1	# i++
	slt	$t3, $t2, $t1	# i < n
	bne     $t3, $zero, loop_print
	
	#print "\n"
	li	$v0, 4
	la	$a0, pnl
	syscall
	
	lw	$ra, 4($fp)	# load return address
	lw	$fp, 0($fp)	# load previous frame pointer
	addi	$sp, $sp, 8	# pop stack (free 8 bytes of $ra and $fp)
	jr	$ra		# return function by jump to return address
	
main:
	#allocate data[]
	addi	$sp, $sp, -48	# allocate 48 bytes for 12 arguments (array data[])
	li	$t0, 132470	# load 132470 to $t0
	sw	$t0, 0($sp)	# store 132470 to data[0]
	li	$t0, 324545	# load 324545 to $t0
	sw	$t0, 4($sp)	# store 324545 to data[1]
	li	$t0, 73245	# load 73245 to $t0
	sw	$t0, 8($sp)	# store 73245 to data[2]
	li	$t0, 93245	# load 93245 to $t0
	sw	$t0, 12($sp)	# store 93245 to data[3]
	li	$t0, 80324542	# load 80324542 to $t0
	sw	$t0, 16($sp)	# store 80324542 to data[4]
	li	$t0, 244	# load 244 to $t0
	sw	$t0, 20($sp)	# store 244 to data[5]
	li	$t0, 2		# load 2 to $t0
	sw	$t0, 24($sp)	# store 2 to data[6]
	li	$t0, 66		# load 66 to $t0
	sw	$t0, 28($sp)	# store 66 to data[7]
	li	$t0, 236	# load 236 to $t0
	sw	$t0, 32($sp)	# store 236 to data[8]
	li	$t0, 327	# load 327 to $t0
	sw	$t0, 36($sp)	# store 327 to data[9]
	li	$t0, 236	# load 236 to $t0
	sw	$t0, 40($sp)	# store 236 to data[10]
	li	$t0, 21544	# load 21544 to $t0
	sw	$t0, 44($sp)	# store 21544 to data[11]
	
	la	$s0, 0($sp)	# load address of data (&data[0]) to $s0
	
	#call printArray(data, N)
	add	$t0, $zero, $s0	# temp for data address
	addi	$t1, $zero, 12	# N = 12 in $t1
	addi 	$sp, $sp, -8	# allocate 8 bytes for 2 arguments (data and N)
	sw	$t0, 0($sp)	# push pointer data to stack
	sw	$t1, 4($sp)	# push N to stack
	jal	printArray
	addi 	$sp, $sp, 8	# pop (clear) stack
	
	#call insertionSortRecursive(data, N)
	add	$t0, $zero, $s0	# temp for data address
	addi	$t1, $zero, 12	# N = 12 in $t1
	addi 	$sp, $sp, -8	# allocate 8 bytes for 2 arguments (data and N)
	sw	$t0, 0($sp)	# push pointer data to stack
	sw	$t1, 4($sp)	# push N to stack
	jal	insertionSortRecursive
	addi 	$sp, $sp, 8	# pop (clear) stack
	
	#call printArray(data, N)
	add	$t0, $zero, $s0	# temp for data address
	addi	$t1, $zero, 12	# N = 12 in $t1
	addi 	$sp, $sp, -8	# allocate 8 bytes for 2 arguments (data and N)
	sw	$t0, 0($sp)	# push pointer data to stack
	sw	$t1, 4($sp)	# push N to stack
	jal	printArray
	addi 	$sp, $sp, 8	# pop (clear) stack
exit:
	li	$v0, 10
	syscall
	
	
