#Esse programa le um vetor de N elementos e escreve no terminal o maior/menor  valor do vetor 
#e suas respectivas posicoes 

.data
	vet: 
	msg1: .asciiz "Leitura de Vetor 1 :\nInsira o numero de elementos:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	msg5: .asciiz "\n O maior elemento foi = "
	msg6: .asciiz "\n Na posição = "
	msg7: .asciiz "\n O menor elemento foi = "
	
.text
	##############Lendo o vetor##################
	
	jal ler_vetor
	addi $s0, $v0, 0 #recebendo o numero de elementos lido
	la $a1,vet  #endereço do primeiro elemento do array
	
	jal menor_maior
	
	li $v0,4
	la $a0,msg5 # imprimindo o maior valor
	syscall
	
	li $v0,1
	add $a0,$zero,$s2
	syscall
	
	li $v0,4
	la $a0,msg6 
	syscall
	
	li $v0,1
	add $s3,$s3,1
	add $a0,$zero,$s3 # imprimindo posição do maior valor 
	syscall
	
	
	
	li $v0,4
	la $a0,msg7 # imprimindo o menor valor
	syscall
	
	li $v0,1
	add $a0,$zero,$s4
	syscall
	
	li $v0,4
	la $a0,msg6
	syscall
	
	li $v0,1
	add $s5,$s5,1
	add $a0,$zero,$s5 # imprimindo posição do menor valor 
	syscall
			
	###########Finalizando o programa############
	addi $v0, $zero, 10
	syscall
	
	
	menor_maior:
		
		li $s2,0 #maior valor
		li $s3,0 #posicao do maior 
		
		li $s4,999999 #menor valor
		li $s5,0 #posicao do menor 
		
		
		li $t2, 0 #indice do vetor 
		li $t4, 0 #aux_posição 
		
		while:
		
			add $t4,$zero,$t2 # salvar posição 
		
			add $t4,$t4,$t4   # 2i
			add $t4,$t4,$t4   # 4i
			add $t1, $t4, $a1 # combinando os dois componentes do endereco 
		
			lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
			
			
			
			bgt $t0,$s2,o_maior
			blt $t0,$s4,o_menor
			
			addi $t2,$t2,1
			blt $t2,$s0,while # if ( i < N ){ while } 
			
			jr $ra
	
	o_maior:
		add $s2,$zero,$t0 # pegando  valor do maior valor 
		add $s3,$zero,$t2 # pegando a posicao do maior valor
		j while 
		jr $ra
		
		
	o_menor:
		add $s4,$zero,$t0 # pegando  valor do menor valor 
		add $s5,$zero,$t2 # pegando a posicao do menor valor
		
		j while
		jr $ra
		#jal while
		
	jr $ra
		
		
	ler_vetor:
		
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		li $v0,4
		la $a0, msg1
		
		syscall	# Imprimir: Leitura de Vetor:
			# Insira o numero de elementos:
		
		li $v0,5
		syscall	# LER numero de elementos(int)
		
		add $s0, $v0, $zero #guardar o valor lido em $s0
		
		la $s1, vet # endereço base do vetor
		add $s2, $zero, $zero # i = 0 
	
		leitura:
		
			sll $t0, $s2, 2 # t0 = 4 * i (i.e, deslocamento)
			add $t0, $t0, $s1 # t0 = deslocamento + endereço base do vetor (t0 == &vetor[i])
			
			li $v0,4
			la $a0, msg2
			syscall  #imprimir: vetor[
			
			li $v0,1
			add $a0, $zero, $s2
			syscall  #imprimir: i
			
			li $v0,4
			la $a0, msg3
			syscall   #imprimir: ] = 
			
			li $v0,5
			syscall	# ler: vetor[i]
			sw $v0, 0($t0) #guardar o valor lido em vetor[i]
			
			addi $s2, $s2, 1 # i++
			bne $s2, $s0, leitura # while(i < numero de elementos do vetor)

		add $v0, $s0, $zero #retornando o numero de elementos lidos para o caller
		
		lw $s0, 0($sp)  #guardando os valores originais de volta em s0/s1/s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12 #desempilhando s0/s1/s2  
		jr $ra #retornando o controle para o chamador
		
	
