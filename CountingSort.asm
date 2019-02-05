.data
    str:    .asciiz "cadljgarhtoxAHdgdsJKhYEasduwBRLsdgHoptxnaseurh"
    ssi:    .asciiz "Sorted string is "
    nline:  .asciiz "\n"
    null:   .asciiz ""
    count:  .space 1024
    output: .space 1000
.text

.globl main # call main by SPIM

main:
    add     $t0, $zero, $zero   # i in $t0 = 0
    lb      $t7, null($zero)    # init null

init_count:
    sll     $t1, $t0, 2         # convert i to word offset
    sw      $zero, count($t1)   # count[i] = 0
    addi	$t0, $t0, 1			# i++
    slti    $t1, $t0, 256       # i < RANGE+1 (256)
    bne     $t1, $zero, init_count

    add     $t0, $zero, $zero   # i in $t0 = 0
    lb      $t1, str($t0)       # load str[i]
store_count:
    sll     $t2, $t1, 2         # convert str[i] to word offset
    lw		$t3, count($t2)		# load count[str[i]]
    addi    $t3, $t3, 1         # ++count[str[i]]
    sw      $t3, count($t2)     # store count[str[i]]
    addi	$t0, $t0, 1			# ++i
    lb      $t1, str($t0)       # load str[i]
    bne     $t1, $t7, store_count

    addi    $t0, $zero, 1       # i = 1
change_count:
    addi    $t1, $t0, -1        # $t1 = i-1
    sll     $t2, $t0, 2         # convert i to word offset
    sll     $t3, $t1, 2         # convert i-1 to word offset
    lw      $t4, count($t2)     # load count[i]
    lw      $t5, count($t3)     # load count[i-1]
    add     $t4, $t4, $t5       # count[i] += count[i-1]
    sw      $t4, count($t2)     # store count[i]
    addi    $t0, $t0, 1         # ++i
    slti    $t1, $t0, 256       # i <= RANGE (<=> i < RANGE+1)
    bne     $t1, $zero, change_count

    add     $t0, $zero, $zero   # i = 0
    lb      $t1, str($t0)       # load str[i]
build_output:
    sll     $t2, $t1, 2         # convert str[i] to word offset
    lw      $t3, count($t2)     # load count[str[i]]
    addi    $t3, $t3, -1        # count[str[i]]-1
    sb      $t1, output($t3)    # store str[i] to output[count[str[i]]-1]
    sw      $t3, count($t2)     # store --count[str[i]]
    addi    $t0, $t0, 1         # ++i
    lb      $t1, str($t0)       # load str[i]
    bne     $t1, $t7, build_output

    add     $t0, $zero, $zero   # i = 0
copy_output:
    lb      $t1, output($t0)    # load output[i]
    sb		$t1, str($t0)		# store output[i] to str[i]
    addi    $t0, $t0, 1         # ++i
    lb      $t1, str($t0)       # load str[i]
    bne     $t1, $t7, copy_output

print_ans:
    #print "Sorted string is "
    li      $v0, 4
    la      $a0, ssi
    syscall

    #print str
    li      $v0, 4
    la      $a0, str
    syscall

    #print "\n"
    li      $v0, 4
    la      $a0, nline
    syscall
    
exit:
    li      $v0, 10
    syscall
    
