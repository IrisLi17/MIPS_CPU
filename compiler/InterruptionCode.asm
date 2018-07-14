#interruption processing code
#假设待显示的两个8bit数放在寄存器$s0和$s1中

addi    $sp, $sp, -28
sw      $t6, 24($sp)
sw      $t5, 20($sp)
sw      $t4, 16($sp)
sw      $t3, 12($sp)
sw      $t2, 8($sp)
sw      $t1, 4($sp)
sw      $t0, 0($sp)

lui     $t0, 0x4000
lw      $t1, 8($t0)
addi    $t2, $zero, 0xFFF9
and     $t1, $t1, $t2
sw      $t1, 8($t0)

#首先检查串口是否有数据接收
lw      $t1, 32($t0) #forwarding
andi    $t2, $t1, 0x0008 #forwarding
beq     $t2, $zero, noload #forwarding
beq     $s5, $zero, loads0 #如果$s0==0，那么向$s0加载数据，否则向$s1加载数据
lw      $s1, 28($t0)
addi    $s6, $s1, 0
j		noload
loads0:
lw      $s0, 28($t0)
addi    $s5, $s0, 0 #s5,s6为gcd中清零准备

#其次实现数码管的扫描显示
noload:
lw		$t1, 20($t0)
srl     $t4, $s1, 4	#本来应位于line 12，插入此处避免stall
andi    $t2, $t1, 0x0100 #forwarding
beq		$t2, $zero, target1	#if... #forwarding
addi    $t3, $zero, 0x0200 #即将点亮AN1
j		finish			

target1:
andi    $t2, $t1, 0x0200 #forwarding
beq     $t2, $zero, target2 #elseif... #forwarding
addi    $t3, $zero, 0x0400 #即将点亮AN2
andi    $t4, $s0, 0x000F
j       finish	

target2:
andi    $t2, $t1, 0x0400 #forwarding
beq     $t2, $zero, target3 #elseif... #forwarding
addi    $t3, $zero, 0x0800 #即将点亮AN3
srl     $t4, $s0, 4
j		finish			

target3: #else...
addi    $t3, $zero, 0x0100 #即将点亮AN0
andi    $t4, $s1, 0x000F

finish:
lw      $t5, 0($t4) #forwarding
add     $t6, $t5, $t3 #forwarding
sw      $t6, 20($t0) #forwarding

lw      $t1, 8($t0)
addi    $t2, $zero, 0x0002
or      $t3, $t1, $t2
sw      $t3, 8($t0)

lw      $t0, 0($sp)
lw      $t1, 4($t1)
lw      $t2, 8($sp)
lw      $t3, 12($sp)
lw      $t4, 16($sp)
lw      $t5, 20($sp)
lw      $t6, 24($sp)
addi    $sp, $sp, 28

jr		$k0