#interruption processing code
#假设待显示的两个8bit数放在寄存器$s0和$s1中

lui     $t0, 0x4000
addi	$t0, $t0, 0x0014 #forwarding
lw		$t1, 0($t0) #forwarding

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
beq     $t2, $t1, target3 #elseif... #forwarding
addi    $t3, $zero, 0x0800 #即将点亮AN3
srl     $t4, $s0, 4
j		finish				

target3: #else...
addi    $t3, $zero, 0x0100 #即将点亮AN0
andi    $t4, $s1, 0x000F

finish:
lw      $t5, 0($t4) #forwarding
sll     $zero, $zero, 0 #这条指令是nop
add     $t6, $t5, $t3 #forwarding
sw      $t6, 0($t0) #forwarding
jr		$k0					