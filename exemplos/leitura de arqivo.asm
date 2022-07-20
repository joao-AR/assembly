#Esse programa executa a leitura de um arquivo e escreve no terminal o seu conteudo
.data 
	localArquivo:.asciiz "leituraMips.txt"
	conteudoArquivo: .space 1024
.text
	#abrir o arquivo no modo de leitura 
	li $v0,13 #solicitar a abertura 
	la $a0,localArquivo #endereço do arquivo em $a0
	li $a1,0 # 0: leitua 1: escrita 
	syscall #Descritor do arquivo vai para $v0
	
	move $s0,$v0 #copiando o descritor de v0 para s0
	
	move $a0,$s0 
	li $v0,14 #ler conteudo do arquivo referenciado por $a0
	
	la $a1,conteudoArquivo #buffer que armazena o conteudo 
	li $a2,1024 #tamanho do buffer
	syscall #leitura realizada
	
	#imprimir 
	li $v0,4
	move $a0,$a1
	syscall
	
	#fechar o arquivo 
	li $v0,16
	move $a0,$s0
	syscall
	
