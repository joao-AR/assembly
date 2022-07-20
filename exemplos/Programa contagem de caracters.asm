#Esse programa realiza a leitura de um arquivo e mostra a quantidade de cacteres existentes no arquivo
.data
	buffer: .asciiz " "
	Arquivo: .asciiz "dados.txt"
	Erro: .asciiz "Arquivo não encontrado!\n"
.text
	
	main:
		la $a0, Arquivo # Nome do arquivo
		li $a1, 0 # Somente leitura
		
		jal abertura # Retorna file descriptor no sucesso

		move $s0, $v0 # Salva o file descriptor em $s0
		move $a0, $s0 # Parâmetro file descriptor
		
		la $a1, buffer # Buffer de entrada
		li $a2, 1 # 1 caractere por leitura
		jal contagem # Retorna em $v0 o num. de carac.

		move $a0, $v0 # Move o resultado para impressão
		li $v0, 1 # Código de impressão de inteiro
		syscall # Imprime o resultado

		li $v0, 16 # Código para fechar o arquivo
		move $a0, $s0 # Parâmetro file descriptor
		syscall # Fecha o arquivo

		li $v0, 10 # Código para finalizar o programa
		syscall # Finaliza o programa

	contagem:
		li $v0, 14 # Código de leitura de arquivo
		syscall # Faz a leitura de 1 caractere
		addi $t0, $t0, 1 # n++
		bnez $v0, contagem # if(ch != EOF) goto contagem
		subi $t0, $t0, 1 # Desconsidera EOF
		move $v0, $t0 # Move o resultado para retorno
		jr $ra # Retorna para a main

	abertura:
		
		li $v0, 13 # Código de abertura de arquivo
		syscall # Tenta abrir o arquivo
		
		bgez $v0, a # if(file_descriptor >= 0) goto a
		la $a0, Erro # else erro: carrega o endereço da string
		li $v0, 4 # Código de impressão de string
		syscall # Imprime o erro
		
		li $v0, 10 # Código para finalizar o programa
		syscall # Finaliza o programa

	a: jr $ra # Retorna para a main
