lui     $t5, 0x4000
sw      $zero, 8($t5)
lui     $t4, 0xffff
addi    $t4, $zero, 0xe000
sw      $t4, 0($t5)
nor     $t6, $zero, $zero
sw      $t6, 4($t5)
addi    $t4, $zero, 0x0003
sw      $t4, 8($t5)

loop:
slt     $t0, $zero, $s0
slt     $t1, $zero, $s1 
and     $t2, $t0, $t1 # forwarding
bne		$t2, $zero, target # forwarding
add		$s2, $s0, $zero # 无关指令，防止阻塞
j		loop
sll     $zero, $zero, 0

target:
add     $s3, $s1, $zero
compare:
slt     $t3, $s2, $s3 # forwarding
beq     $t3, $zero, s2greater # forwarding
sll     $zero, $zero, 0 # stall
add     $t4, $s2, $zero # if $s3 is greater, swap
add     $s2, $s3, $zero
add     $s3, $t4, $zero # forwarding
s2greater:
sub     $s4, $s2, $s3
beq     $s4, $zero, finish # forwarding
sll     $zero, $zero, 0 # stall
add     $s2, $s3, $zero
add     $s3, $s4, $zero
j		compare
sll     $zero, $zero, 0 # stall

finish: # $s3 is gcd
lui     $t5,0x4000
sw		$s3, 24($t5) # uart_txd
sw      $s3, 12($t5) # led
j		Exit		 # 手动加机器码
Exit:
lui     $t0,0x4000
lw		$t1, 32($t0)		# $t1 = uart_con
addi	$t2, $zero, 8			# $t2 = 8
and     $t1,$t1,$t2
# sll     $t1,$t1,0
bne		$t1, $zero, loop
j		Exit				# jump to Exit
