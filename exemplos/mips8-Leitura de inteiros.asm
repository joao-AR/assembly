.data 
	saudacao: .asciiz "olá,por favor, dorneça sua idade:"
	saida: .asciiz "Sua idade é"
	
.text 
	li $v0,4 #imprimir uma string 
	la $a0, saudacao
	syscall
	
	li $v0,5 #leitura de interios 
	syscall 
	
	move $t0, $v0 # o valor passado está em t0
	
	li $v0,4  #imprimir uma string
	la $a0,saida
	syscall
	
	li $v0,1 #imprimir inteiros 
	move $a0,$t0
	syscall  
