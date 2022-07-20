.data
	msg: .asciiz "Forneça um numero: "
	par: .asciiz "o numero é par."
	impar:.asciiz "o numero é impar."

.text 
	#imprimindo mensagem para o usuário
	li $v0,4
	la $a0,msg
	syscall
	
	#ler o numero 
	li $v0,5
	syscall
	
	li $t0,2
	div $v0,$t0
	
	mfhi $t1 #possui o resto da divisão por 2
	
	beq $t1,$zero,imprimePar # beq = t1 == zero
	li $v0,4
	la $a0,impar
	syscall
	
	#encerra o programa 
	li $v0,10
	syscall
	
		imprimePar:
		li $v0,4
		la $a0,par
		syscall	