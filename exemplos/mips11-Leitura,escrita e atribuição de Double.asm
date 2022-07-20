.data 
	msg: .asciiz "forneça um número em decimal"
	zero: .double 0.0
	
.text 
	#imprimindo mensagem para o usuario 
	li $v0,4
	la $a0,msg
	syscall
	
	#lendo o numero 
	li $v0,7
	syscall #valor lido estará em $f0
	
	ldc1 $f2,zero
	add.d $f12,$f2,$f0
	
	#imprimindo o numero
	li $v0,3
	syscall
	
	