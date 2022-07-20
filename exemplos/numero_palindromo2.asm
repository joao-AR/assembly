.data

numero: .asciiz	"5665"
tamanho_palindromo: .word 1

msg_e: .asciiz	" É"
msg_nao: .asciiz" Não é "
msg_palindromo: .asciiz	" um palindromo!"	

.text
	la	$a0, tamanho_palindromo	# coloca o tamanho do possivel palindromo em $a0
	lw	$a0, 0($a0)
	
	la	$a1, numero # o numero é colocado em $a1
	
	li $t1,2 # divisão 
	
	div $a0,$t1 # dividindo o tamanho do palindromo por 2 
	mfhi $s1 # o resto da divisão vai para $s1
	
	bnez $s1,nao_palindromo
	blt $a0,$t1,nao_palindromo # se tiver menos que dois algarismos 
	
	jal 	verificar_palindromo # Vendo se é palindromo
	add	$a0, $v0, $zero
	
	jal	imprime_resultado # imprimim o resultado 
	
	addi	$v0, $zero, 10 #encerra o programa
	syscall	


nao_palindromo:
	li $v0,4
	la $a0,msg_nao
	syscall
	
	li $v0,4
	la $a0,msg_palindromo
	syscall
	
	li $v0,10
	syscall
	
verificar_palindromo:
	
	slti	$t0, $a0, 2
	bne	$t0, $zero,sim

	# Verificando se o ultimo é igual ao primeiro 
	
	lb	$t0, 0($a1)
	addi	$t1, $a0, -1 # $t1 = $a0 nao posicão  -1 
	
	add	$t1, $t1, $a1 # $t1 recebe $t1 + string (numero) passado
	lb	$t1, 0($t1)
	
	bne	$t0, $t1, nao #  Se $t0 o inicial não é igual ao ultimo $t1 não é palindromo
	
	# desloca o ponteiro 
	
	addi	$a0, $a0, -2 
	addi	$a1, $a1, 1 #proxima posi
	j	verificar_palindromo
	
nao:
	addi	$v0, $zero, 0
	jr	$ra

sim:
	addi	$v0, $zero, 1
	jr	$ra

imprime_resultado:
	
	add	$t4, $a0, $zero	
	
	addi	$v0, $zero, 4
	la	$a0, numero
	syscall	 # imprime o numero passado
	
	la	$a0,msg_e #msg É
	syscall	
	
	bne	$t4, $zero, imprimir_final
		la $a0, msg_nao 
		syscall		# imprimir Não é 

imprimir_final:
	la $a0, msg_palindromo
	syscall	# um  palindormo"
	jr	$ra
	
	
	