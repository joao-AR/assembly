#Soma os valores das posições pares do vetor 
.data 
	vet1: .word 6,2,3,4 # 1,3 indices pares
	msg1: .asciiz "\n vetor 1 = "
	
.text 
	
	la $s2,vet1 #endereco do vetor 1 em $s2

	
	li $t2, 0 #indice do vetor 1 
	li $t4, 0 #aux_posição
	li $t5, 0 #soma 
	
	
	while: # vai andar pelo vetores 
		
		add $t4,$zero,$t2 # salvar posição 
		
		add $t4,$t4,$t4  # 2i
		add $t4,$t4,$t4   # 4i
		add $t1, $t4, $s2 # combinando os dois componentes do endereco 
		
		li $v0,4
		la $a0,msg1
		syscall
		
		lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
		li $v0,1
		add $a0,$zero,$t0
		add $t5,$t5,$a0
		syscall
		
		addi $t2,$t2,2
		
		blt $t2,4,while # if ( i < 4 ){ while } 
		
		###########Finalizando o programa############
	addi $v0, $zero, 10
	syscall
		
		
		
		
		

	
	
