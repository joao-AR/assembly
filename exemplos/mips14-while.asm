.data 
	espaco: .byte ' ' 
.text 
	#ler o numero
	li $v0,5
	syscall
	
	move $t0,$v0 #valor lido para t0
	
	move $t1,$zero
	
	laco:
		bgt $t1,$t0,sair
		
		#imprimir $t1
		
		li $v0,1
		move $a0,$t1
		syscall
		
		#imprimir espaço em branco 
		li $v0,4
		la $a0,espaco
		syscall
		
		addi $t1,$t1,1
		j laco
	sair: