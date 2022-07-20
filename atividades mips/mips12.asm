

.data
	vet: 
	msg1: .asciiz "Leitura de Vetor 1 :\nInsira o numero de elementos:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	msg4: .asciiz "\n O número de elementos menores que a soma dos N elementos lidos é =  "
	msg5: .asciiz "\n O número de elementos ímpares é = "
	msg6: .asciiz "\nNão há elementos ímpares no vetor!"
	msg7: .asciiz "\n O produto da posição do menor elemento par do vetor com a posição do maior elemento ímpar do vetor é = "
	msg8: .asciiz "\nNão há elementos pares no vetor!"
	msg9: .asciiz "\n"
	msg10: .asciiz ""
.text
	##############Lendo o vetor##################
	
	jal ler_vetor
	addi $s0, $v0, 0 #recebendo o numero de elementos lido
	la $a1,vet  #endereço do primeiro elemento do array
	
	#A)
	jal somatorio_N
	jal compara_N
	
	li $v0,4
	la $a0,msg4
	syscall
	
	li $v0,1
	add $a0,$s6,$zero
	syscall
	
	#B)
	jal compara_impar
	bgtz $s7,tem_impares
	
	#C)
	jal Maior_par_impar
	
	
	li $v0,4
	la $a0,msg7
	syscall
	
	li $v0,1
	
	mult $s1,$s2
	mflo $a0
	syscall
	
	###########Finalizando o programa############
	addi $v0, $zero, 10
	syscall
	

#----------------------------------------------------------#
	sem_impares:
		li $v0,4
		la $a0,msg6
		syscall
	jalr $ra
	
	tem_impares:
		li $v0,4
		la $a0,msg5
		syscall
		
		li $v0,1
		add $a0,$s7,$zero
		syscall
		li $s7,0
	jr $ra

#----------------------------------------------------------#
	
	Maior_par_impar:
		
		li $t5,2 #divisão
		
		li $t2, 0 #indice do vetor 1 
		li $t4, 0 #aux_posição
		
		li $t6,0 #maior par
		li $s1,0 #posição maior par
		
		li $t7,0 #maior impar
		li $s2,0 #posição maior impar
		
		while_par_impar:
		
			add $t4,$zero,$t2 # salvar posição 
		
			add $t4,$t4,$t4   # 2i
			add $t4,$t4,$t4   # 4i
			add $t1, $t4, $a1 # combinando os dois componentes do endereco 
		
			lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
			
			div $t0,$t5 # valor atual / 2 
			mfhi $s7 # resto da divisão
			
			
			beqz $s7,maior_par 
			bgtz $s7,maior_impar
			addi $t2,$t2,1
		
			blt $t2,$s0,while_par_impar # if ( i < tamanho ){ while } 
			
		jr $ra
	
	#-----#	
	maior_par:
		bgt $t0,$t6,att_M_par
		addi $t2,$t2,1
		blt $t2,$s0,while_par_impar
	jr $ra
	
	att_M_par:
	 	add $t6,$t0,$zero
	 	add $s1,$t2,$zero
	 j maior_par
	 
	 #------#
	 maior_impar:
		bgt $t0,$t7,att_M_impar
		addi $t2,$t2,1
		blt $t2,$s0,while_par_impar
	jr $ra
	
	att_M_impar:
	 	add $t7,$t0,$zero
	 	add $s2,$t2,$zero
	 j maior_impar
	 
#----------------------------------------------------------# 
	
	somatorio_N:
		
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
		
			addi $t2,$t2,1
		
			blt $t2,$s0,while_soma # if ( i < tamanho ){ while } 
			
		jr $ra
		
	compara_N: 
		li $t1, 2 #valor divisão
		li $t2, 0 #indice do vetor 1 
		li $t4, 0 #aux_posição
		li $t5, 0 # Resto divisão divisão B)
		
		li $s6, 0 #soma de menores que a soma de N  A)
		li $s7, 0 #Quantidade de elementos impares B)
		
		while_compara_N:
		
			add $t4,$zero,$t2 # salvar posição 
		
			add $t4,$t4,$t4  # 2i
			add $t4,$t4,$t4   # 4i
			add $t1, $t4, $a1 # combinando os dois componentes do endereco 
		
			lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
			addi $t2,$t2,1
			
			blt $t0,$s5,soma_N # A) compara se t0 < soma dos N elementos 
		
			blt $t2,$s0,while_compara_N # if ( i < tamanho ){ while } 
			
		jr $ra
		
		soma_N: 
			addi $s6,$s6,1
			blt $t2,$s0,while_compara_N
		jr $ra
		
		
	compara_impar: #B)
		li $t6, 2 #valor divisão
		
		li $t2, 0 #indice do vetor 1 
		li $t4, 0 #aux_posição
		li $t5, 0 #aux
		li $s6, 0 # Resto divisão divisão B)
		li $s7, 0 #Quantidade de elementos impares B)
		
		while_compara_impar:
		
			add $t4,$zero,$t2 # salvar posição 
		
			add $t4,$t4,$t4  # 2i
			add $t4,$t4,$t4   # 4i
			add $t1, $t4, $a1 # combinando os dois componentes do endereco 
		
			lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
			addi $t2,$t2,1
			add $t5,$t0,$zero
			div $t5,$t6
			mfhi $s6 #pegando resto da divisão do elemento
			
			bgtz  $s6,soma_impar # soma a quantidade de elementos impares
		
			blt $t2,$s0,while_compara_impar # if ( i < tamanho ){ while } 
			
		jr $ra
		
		soma_impar: 
			addi $s7,$s7,1
			blt $t2,$s0,while_compara_impar
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
		
	
	
		
	
