.data
M:		.asciiz "\nMultiplicando: "
m:		.asciiz "\nMultiplicador: "
rpta:		.asciiz "\n\nResultado: "
.text
.globl main
main:
	addi $sp, $sp, -56
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $t0, 28($sp)
	sw $t1, 32($sp)
	sw $t2, 36($sp)

	move $s0, $zero
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero

	# Multiplicador
	li   $v0, 4
	la   $a0, m
	syscall
	li   $v0, 5
	syscall
	move $a0,$v0
	sw $a0, 40($sp)
	move  $s1, $a0

	# Multipicando
	li   $v0, 4
	la   $a0, M
	syscall
	li   $v0, 5
	syscall
	move $a1,$v0
	sw $a1, 44($sp)
	move  $s2, $a1

_step:

	beq  $s0, 33, exit
	andi $t0, $s1, 1		
	beq  $t0, $zero, x_lsb_0	
	j    x_lsb_1			
x_lsb_0: 				
	beq  $s5, $zero, _00	
	j    _01			
x_lsb_1:				
	beq  $s5, $zero, _10	
	j    _11			
_00:
	andi $t0, $s3, 1		
	bne  $t0, $zero, V		
	srl  $s4, $s4, 1		
	j    shift			
_01:
	beq  $s2, -2147483648, _add
	add  $s3, $s3, $s2		
	andi $s5, $s5, 0		
	andi $t0, $s3, 1		
	bne  $t0, $zero, V		
	srl  $s4, $s4, 1		
	j    shift			
_10:
	beq  $s2, -2147483648, _sub
	sub  $s3, $s3, $s2		
	ori  $s5, $s5, 1		
	andi $t0, $s3, 1		
	bne  $t0, $zero, V		
	srl  $s4, $s4, 1		
	j    shift			
_11:
	andi $t0, $s3, 1		
	bne  $t0, $zero, V		
	srl  $s4, $s4, 1		
	j    shift 			
V:
	andi $t0, $s4, 0x80000000	
	bne  $t0, $zero, v_msb_1	
	srl  $s4, $s4, 1		
	ori  $s4, $s4, 0x80000000	
	j    shift			
v_msb_1:
	srl  $s4, $s4, 1		
	ori  $s4, $s4, 0x80000000	
	j    shift			

shift:
	sra  $s3, $s3, 1		
	ror  $s1, $s1, 1		
	addi $s0, $s0, 1		
	beq  $s0, 32, save		
	j    _step			
save:
	add  $t1, $zero, $s3		
	add  $t2, $zero, $s4		
	j    _step			
_sub:			
	subu $s3, $s3, $s2	
	andi $s6, $s6, 0	
	ori  $s5, $s5, 1	
	andi $t0, $s3, 1	
	bne  $t0, $zero, V	
	srl  $s4, $s4, 1	
	j    shift_special	

_add:			
	addu $s3, $s3, $s2	
	ori  $s6, $s6, 1	
	andi $s5, $s5, 0	
	andi $t0, $s3, 1	
	bne  $t0, $zero, V	
	srl  $s4, $s4, 1	
	j    shift_special	
	
	
shift_special:
	beq  $s6, $zero, n_0	
	sra  $s3, $s3, 1		
	ror  $s1, $s1, 1		
	addi $s0, $s0, 1		
	beq  $s0, 32, save		
	j    _step			
n_0:
	srl  $s3, $s3, 1		
	ror  $s1, $s1, 1		
	addi $s0, $s0, 1		
	beq  $s0, 32, save		
	j    _step			
exit:
	move $v0,$t1
	sw $v0, 48($sp)
	move $v1,$t2
	sw $v1, 52($sp)
	# Resultado
	li   $v0, 4
	la   $a0, rpta
	syscall
	lw $s0, ($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $a0, 40($sp)
	lw $a1, 44($sp)
	# A
	lw $v0, 48($sp)
	move $a0, $v0
	li   $v0, 35
	syscall
	# Q
	lw $v1, 52($sp)
	move  $a0, $v1
	li   $v0, 35
	syscall
	addi $sp, $sp, 40
	#Salir
	li   $v0, 10
	syscall
