.data 
	pergunta: .asciiz "qual é o seu nome ? "
	saudacao: .asciiz "olá, "
	nome: .space 25
.text
	#impressão da perguta 
	li $v0,4
	la $a0,pergunta
	syscall
	
	#leitura do nome 
	li $v0,8
	la $a0,nome
	la $a1,25 # 25 -> tamanho  do maximo do nome
	syscall
	
	#mostrar a saudação
	li $v0,4
	la $a0,saudacao
	syscall
	
	#impressão do nome
	li $v0,4
	la $a0,nome
	syscall 