#interruption processing code
#假设待显示的两个8bit数放在寄存器$s0和$s1中

lui     $t0, 0x4000
lw      $t1, 8($t0)
addi    $t2, $zero, 0xFFF9
and     $t1, $t1, $t2
sw      $t1, 8($t0)

#首先检查串口是否有数据接收
lw      $t1, 32($t0) #forwarding
sll     $zero, $zero, 0 #空指令
andi    $t2, $t1, 0x0008 #forwarding
beq     $t2, $zero, noload #forwarding
sll     $zero, $zero, 0 #空指令
beq     $s0, $zero, loads0 #如果$s0==0，那么向$s0加载数据，否则向$s1加载数据
sll     $zero, $zero, 0 #空指令
lw      $s1, 28($t0)
j		noload
sll     $zero, $zero, 0 #空指令
loads0:
lw      $s0, 28($t0)


#其次实现数码管的扫描显示
noload:
lw		$t1, 20($t0)

srl     $t4, $s1, 4	#本来应位于line 12，插入此处避免stall
andi    $t2, $t1, 0x0100 #forwarding
beq		$t2, $zero, target1	#if... #forwarding
sll     $zero, $zero, 0 #空指令
addi    $t3, $zero, 0x0200 #即将点亮AN1
j		finish	
sll     $zero, $zero, 0 #空指令			

target1:
andi    $t2, $t1, 0x0200 #forwarding
beq     $t2, $zero, target2 #elseif... #forwarding
sll     $zero, $zero, 0 #空指令
addi    $t3, $zero, 0x0400 #即将点亮AN2
andi    $t4, $s0, 0x000F
j       finish	
sll     $zero, $zero, 0 #空指令

target2:
andi    $t2, $t1, 0x0400 #forwarding
beq     $t2, $t1, target3 #elseif... #forwarding
sll     $zero, $zero, 0 #空指令
addi    $t3, $zero, 0x0800 #即将点亮AN3
srl     $t4, $s0, 4
j		finish			
sll     $zero, $zero, 0 #空指令	

target3: #else...
addi    $t3, $zero, 0x0100 #即将点亮AN0
andi    $t4, $s1, 0x000F

finish:
lw      $t5, 0($t4) #forwarding
sll     $zero, $zero, 0 #这条指令是nop
add     $t6, $t5, $t3 #forwarding
sw      $t6, 20($t0) #forwarding

lw      $t1, 8($t0)
ori     $t1, $t1, 0x0002
sw      $t1, 8($t0)

jr		$k0					