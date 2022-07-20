.data
	vet:
	vet_ordendado:
	msg1: .asciiz "Leitura de Vetor:\nInsira o numero de elementos:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	msg4: .asciiz "\nElementos do vetor:\n"
	
.text
	##############Lendo o vetor##################
	jal ler_vetor
	addi $a0, $v0, 0 #recebendo o numero de elementos lido
	la $a1,vet  #endereço do primeiro elemento do array
	
	jal Ordenacao_crescente
	addi $a0, $v0, 0 #recebendo o numero de elementos lido
	la $a1,vet  #endereço do primeiro elemento do array
	jal Ordenacao_decrescente 

	li $v0,10
	syscall
			

	
	ler_vetor:
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		li $v0,4
		la $a0, msg1
		syscall	# imprimir: Leitura de Vetor:
			# 	    Insira o numero de elementos:
		
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
		
	
	####### Ordenação #########
	Ordenacao_crescente:
	
	addi $sp,$sp,-40
	
	#guardando os valores na pilha
	sw $ra,36 ($sp)
	sw $a0,32 ($sp)
	sw $a1,28 ($sp)
	sw $t0,24 ($sp)
	sw $t1,20 ($sp)
	sw $t2,16 ($sp)
	sw $t3,12 ($sp)
	sw $t4,8  ($sp)
	sw $t5,4  ($sp)
	sw $t6,0  ($sp)
	
	li $t0,1 #troca = 1
		
		while: 
		bne $t0,1 end_while #se $t0 diferente de 1, saia do loop
		li $t0,0 #troca = 0
		
		move $t1,$zero #i=0
		
		for: 
			mul $t2,$t1,4 #calculando o valor do offset para pegar valores[i]
			add $t2,$t2,$a1 #adicionando o offset para encontar o endereço de valor
			lw $t3,0($t2) #aux = valores[i]
			
			addi $t4,$t1,1 #$t4 recebe valores[i+1]
			mul  $t4,$t4,4 #calculando o valor do offser para pegar valores[i+1]
			add $t4,$t4,$a1 #adicionando o offser para encontrar o endereço valores
			lw $t5, 0($t4)
			
			#condilção de troca 
			
			slt $t6,$t3,$t5 # se valores[i] < valores[i+1], $t6 recebe 1 
			beq $t6,1,end_for # se valores[i] < valores [ i+]
			beq $t3,$t5, end_for # se valores [i] = valores[i+1]
			
			#realizar troca
			li $t0,1	#troca = 1
			sw $t5,0($t2)	#valores[i] = valores[i+1]
			sw $t3,0($t4) 	# valores[i+1] = aux
			
				
				# final do for 
				end_for: 
				addi $t1,$t1,1  #incrementando: i++
				subi $t2,$a0,1  # $t2 recebe tamano do array - 1
				slt $t2,$t1,$t2 # se i < (tamanho do array -1), $t2 recebe 1
				beq $t2,1,for   #se $t2 igual a 1, então repita o loop
			
			#final do while 
			j while
			
			
		end_while:
			#restaurando os valores da pilha nos registradores
			
			 lw $t6,0 ($sp) 
			 lw $t5,4($sp)
			 lw $t4,8 ($sp)
			 lw $t3,12 ($sp)
			 lw $t2,16($sp)
			 lw $t1,20 ($sp)
			 lw $t0,24 ($sp)
			 lw $a1 ,28 ($sp)
			 lw $a0 ,32 ($sp)
			 lw $ra ,36 ($sp)
			 addi $sp,$sp,40 #restaurar o ponteiro da pilha 
			 
			 jr $ra #voltando pra o ponto que chamou a função 
			
	
	Ordenacao_decrescente:
	
	addi $sp,$sp,-40
	
	#guardando os valores na pilha
	sw $ra,36 ($sp)
	sw $a0,32 ($sp)
	sw $a1,28 ($sp)
	sw $t0,24 ($sp)
	sw $t1,20 ($sp)
	sw $t2,16 ($sp)
	sw $t3,12 ($sp)
	sw $t4,8  ($sp)
	sw $t5,4  ($sp)
	sw $t6,0  ($sp)
	
	li $t0,1 #troca = 1
		
		while_2: 
		bne $t0,1 end_while_2 #se $t0 diferente de 1, saia do loop
		li $t0,0 #troca = 0
		
		add $t7,$zero,$a0 #$t7 recebe a qunatidade de valores 
		li $t8, 2 #para dividir a quantidade de valores por 2
		div $t7,$t8
		mflo $s0
		
		add $t1,$zero,$s0 #  i = metade do vetor 
		
		for_2: 
			mul $t2,$t1,4 #calculando o valor do offset para pegar valores[i]
			add $t2,$t2,$a1 #adicionando o offset para encontar o endereço de valor
			lw $t3,0($t2) #aux = valores[i]
			
			addi $t4,$t1,1 #$t4 recebe valores[i+1]
			mul  $t4,$t4,4 #calculando o valor do offser para pegar valores[i+1]
			add $t4,$t4,$a1 #adicionando o offser para encontrar o endereço valores
			lw $t5, 0($t4)
			
			#condilção de troca 
			
			sgt $t6,$t3,$t5 # se valores[i] < valores[i+1], $t6 recebe 1 
			beq $t6,1,end_for_2 # se valores[i] < valores [ i+]
			beq $t3,$t5, end_for_2 # se valores [i] = valores[i+1]
			
			#realizar troca
			li $t0,1	#troca = 1
			sw $t5,0($t2)	#valores[i] = valores[i+1]
			sw $t3,0($t4) 	# valores[i+1] = aux
			
				
				# final do for 
				end_for_2: 
				addi $t1,$t1,1  #incrementando: i++
				subi $t2,$a0,1  # $t2 recebe tamano do array - 1
				slt $t2,$t1,$t2 # se i < (tamanho do array -1), $t2 recebe 1
				beq $t2,1,for_2   #se $t2 igual a 1, então repita o loop
			
			#final do while 
			j while_2
			
			
		end_while_2:
			#restaurando os valores da pilha nos registradores
			
			 lw $t6,0 ($sp) 
			 lw $t5,4($sp)
			 lw $t4,8 ($sp)
			 lw $t3,12 ($sp)
			 lw $t2,16($sp)
			 lw $t1,20 ($sp)
			 lw $t0,24 ($sp)
			 lw $a1 ,28 ($sp)
			 lw $a0 ,32 ($sp)
			 lw $ra ,36 ($sp)
			 addi $sp,$sp,40 #restaurar o ponteiro da pilha 
			 
			 jr $ra #voltando pra o ponto que chamou a função
			 
	
	