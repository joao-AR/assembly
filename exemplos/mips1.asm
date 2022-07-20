.data 
	#area para dados da memoria principal 
	msg: .asciiz "teste" #mensagem
.text 
	#area para instruções do programa 
	
	li $v0,4 	#instrução para impressão de string
	la $a0,msg 	#indicar o endereço en que está a mensagem
	syscall 	#vai imprimir