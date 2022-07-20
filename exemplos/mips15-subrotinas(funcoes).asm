.data
	msgUsr: .asciiz "Forneça um número positivo: "
	msgPar: .asciiz "o numero é par."
	msgImpar: .asciiz "o numero é impar."
.text
	la $a0,msgUsr
	jal imprimeString
	jal lerInteiro
	
	move $a0,$v0
	jal ehImpar
	beq $v0,$zero,imprimePar
	la $a0,msgImpar
	jal imprimeString
	jal encerraPrograma
	
	imprimePar: 
		la $a0,msgPar
		jal imprimeString
		jal encerraPrograma
	
	#função que verifica se o argumento $a0 é impar 
	#retorna 1 se for impar
	#retorna 0 se for par
	
	ehImpar: 
		li $t0,2
		div $a0,$t0
		
		mfhi $v0
		jr $ra #retonando para quem chamou a função 
		
	imprimeString:
	li $v0,4
	syscall 
	jr $ra
	
	lerInteiro: 
	li $v0,5
	syscall
	jr $ra
	
	encerraPrograma: 
		li $v0,10
		syscall
	