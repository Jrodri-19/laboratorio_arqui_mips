.data
msm_bs: .asciiz "Ingrese la base: "
msm_exp: .asciiz "Ingrese el exponente: "
msm_rpta: .asciiz "El resultado es: "

.text
.globl _main
.globl  _pot  # Definir etiqueta global para el procedimiento

_main:
    # Guardado de datos en la pila
    li $t0, 101
    li $t1, 111
    li $t2, 131
    li $t3, 141
    addi $sp, $sp, -24
    sw $t0, ($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)

    # Llectura de base
    li $v0, 4             
    la $a0, msm_bs
    syscall               
    li $v0, 5             
    syscall 
    move $a0, $v0 
    sw $a0, 16($sp)
    move $t0, $a0 

    # Lectura de exponente
    li $v0, 4      
    la $a0, msm_exp
    syscall        
    li $v0, 5      
    syscall        
    move $a1, $v0    
    sw $a1, 20($sp)
    move $t1, $a1  
    
    # Llamar al procedimiento para calcular la potencia
    jal _pot
    sw $v0, 24($sp)
    # Imprimir respuesta
    li $v0, 4            	
    la $a0, msm_rpta
    syscall 	
    # Restaurar los valores de la pila a sus respectivas variables
    lw $t0, ($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $a0, 16($sp)
    lw $a1, 20($sp)
    lw $v0, 24($sp)
    # Liberar espacio en la pila antes de salir
    addi $sp, $sp, 24
    move $a0, $v0
    li $v0, 1             	
    syscall  
    li $v0, 10            	
    syscall 

# Procedimiento para calcular la potencia
_pot:
    li $t2, 0    # Inicializar contador
    li $t3, 1    # Inicializar respuesta
loop_pot:
    bge $t2, $t1, break_loop
    mul $t3, $t3, $t0
    addi $t2, $t2, 1
    j loop_pot
break_loop:
    move $v0, $t3
    jr $ra 
