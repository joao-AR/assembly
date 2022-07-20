# Esse programa le dois vetores de n elementos e subtrai os elementos das posições pares do vet A com as posições impares do vet B

.data
	vet: # vet A
	vet_2: # vet B
	msg1: .asciiz "Leitura de Vetor 1 :\nInsira o numero de elementos:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	msg4: .asciiz "\n Elementos do vetor1:\n"
	msg5: .asciiz "\n A soma dos falores pares foi de = "
	msg6: .asciiz "\nLeitura de Vetor 2 :\nInsira o numero de elementos:\n"
	msg7: .asciiz "\nvetA - vetB = "
	
.text
	##############Lendo o vetor##################
	
	jal ler_vetor
	addi $s0, $v0, 0 #recebendo o numero de elementos lido
	la $a1,vet  #endereço do primeiro elemento do array
	
	jal somatorio_posi_par
	
	
	jal ler_vetor_2
	addi $s0, $v0, 0 #recebendo o numero de elementos lido
	la $a1,vet_2  #endereço do primeiro elemento do array
	
	jal somatorio_posi_impar
	
	li $v0,4
	la $a0, msg7
	syscall  #Elementos do vetor:
	
	sub $t0,$s5,$s6 # $t0 recebe a subtração
	
	li $v0,1
	add $a0,$t0,$zero
	syscall
	
	
	###########Finalizando o programa############
	addi $v0, $zero, 10
	syscall
	
	
	somatorio_posi_par:
		
		li $t2, 0 #indice do vetor 1 
		li $t4, 0 #aux_posição
		li $s5, 0 #soma 
		
		while_soma:
		
			add $t4,$zero,$t2 # salvar posição 
		
			add $t4,$t4,$t4  # 2i
			add $t4,$t4,$t4   # 4i
			add $t1, $t4, $a1 # combinando os dois componentes do endereco 
		
			lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
			add $s5,$s5,$t0
		
			addi $t2,$t2,2
		
			blt $t2,$s0,while_soma # if ( i < 4 ){ while } 
	
			
		jr $ra
		
		
	somatorio_posi_impar:
		
		li $t2, 1 #indice do vetor 1 
		li $t4, 0 #aux_posição
		li $s6, 0 #soma 
		
		while_soma_impar:
		
			add $t4,$zero,$t2 # salvar posição 
		
			add $t4,$t4,$t4   # 2i
			add $t4,$t4,$t4   # 4i
			add $t1, $t4, $a1 # combinando os dois componentes do endereco 
		
			lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
			add $s6,$s6,$t0
		
			addi $t2,$t2,2
		
			blt $t2,$s0,while_soma_impar # if ( i < 4 ){ while } 
	
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
		
	
	ler_vetor_2:
		
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		li $v0,4
		la $a0, msg6
		syscall	# imprimir: Leitura de Vetor:
			# Insira o numero de elementos:
		
		li $v0,5
		syscall	# LER numero de elementos(int)
		
		add $s0, $v0, $zero #guardar o valor lido em $s0
		
		la $s1, vet_2 # endereço base do vetor
		add $s2, $zero, $zero # i = 0 
	
		leitura_2:
		
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
			bne $s2, $s0, leitura_2 # while(i < numero de elementos do vetor)

		add $v0, $s0, $zero #retornando o numero de elementos lidos para o caller
		
		lw $s0, 0($sp)  #guardando os valores originais de volta em s0/s1/s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12 #desempilhando s0/s1/s2  
		jr $ra #retornando o controle para o chamador
		
	
