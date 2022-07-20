.data 
	maior: .asciiz "o numero é maior que zero."
	menor: .asciiz "o numero é menor que zero."
	igual: .asciiz "o numero é igual a zero"

.text 
	#ler o numero inteiro 
	li $v0,5
	syscall
	
	move $t0,$v0
	
	beq $t0,$zero,imprimeIgual
	bgt $t0, $zero, imprimeMaior
	blt $t0,$zero,imprimeMenor
	
	imprimeIgual:
		li $v0,4
		la $a0,igual
		syscall
		
		li $v0,10
		syscall
	imprimeMaior: 
		li $v0,4
		la $a0,maior
		syscall
		
		li $v0,10
		syscall
		
	imprimeMenor: 
		li $v0,4
		la $a0,menor
		syscall
		
		li $v0,10
		syscall
	