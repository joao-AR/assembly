
.data
	vet:
	vet_ordendado:
	msg1: .asciiz "Leitura de Vetor:\nInsira o numero de elementos:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	msg4: .asciiz "\n Elementos do vetor:\n"
	msg5: .asciiz "\n A soma dos falores pares foi de = "
	msg6: .asciiz "\n Digite um numero K: "
	
	msg7: .asciiz "\n quantidade de numeros maiores que K = "
	msg8: .asciiz "\n Quantidade de numeros menores que 2*K = "
	msg9: .asciiz "\n Quantidade de numeros iguais que K = "

	
	
.text
	##############Lendo o vetor##################
	jal ler_vetor
	addi $s0, $v0, 0 #recebendo o numero de elementos lido
	la $a1,vet  #endereço do primeiro elemento do array
	
	jal Ordenacao_crescente
	jal Somatario_pares
	jal maior_K
	
	addi $t2, $zero, 0 # i = 0	
	li $v0,4
	la $a0, msg4
	syscall  #Elementos do vetor:
	
	print_loop:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $a1 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i)	
			
			lw $t1, 0($t3)
			
			la $a0, msg2 
			add $a2, $t2, $zero 
			jal imprimir_string_seguida_de_inteiro
			la $a0, msg3 
			add $a2, $t1, $zero 
			jal imprimir_string_seguida_de_inteiro
			
			addi $t2, $t2, 1 #i++
			bne $s0, $t2, print_loop
		
	###########Finalizando o programa############
	addi $v0, $zero, 10
	syscall
	
	
	maior_K: # vai andar pelo vetor somando os valores nas posições pares 
		
		li $t2, 0 #indice do vetor 
		li $t4, 0 #aux_posição
		
		li $s5, 0 #contador maior k
		li $s6, 0 #contador menor 2*k
		li $s7, 0 #contador igual K
		
		li $v0,4
		la $a0,msg6 #msg ler K
		syscall
		
		li $v0,5
		syscall	# LER numero K
		
		add $s4, $v0, $zero #guardar o valor lido em $s4
		add $t6,$s4,$s4
		jal while_k
		
		jr $ra
		
		while_k:
			add $t4,$zero,$t2 # salvar posição
			add $t4,$t4,$t4   # 2i
			add $t4,$t4,$t4   # 4i
			add $t1, $t4, $a1 # combinando os dois componentes do endereco 
		
			lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
			
			beq $t0,$s4,contador_igual
			bgt $t0,$s4,contador_maior
			blt $t0,$t6,contador_menor
			
			addi $t2,$t2,1 # i = i+1
			

			blt $t2,$s0,while_k # if ( i <= final ){ while }
			jal fim_while
			jr $ra #retornando o controle para o chamador
			
			fim_while:
				
				li $v0,4
				la $a0,msg7 #escrevedo a msg maior
				syscall
			
				li $v0,1
				add $a0,$zero,$s5 # escrevendo o resultado da soma
				syscall
				
				
				li $v0,4
				la $a0,msg8 #escrevedo a msg menor 2k
				syscall
			
				li $v0,1
				add $a0,$zero,$s6 # escrevendo o resultado da soma
				syscall
	
				li $v0,4
				la $a0,msg9 #escrevedo a msg igual
				syscall
			
				li $v0,1
				add $a0,$zero,$s7 # escrevendo o resultado da soma
				syscall
				
				jr $ra 
			
				
	
	contador_maior:	
			add $s5,$s5,1 #soma mais um no contador 
			addi $t2,$t2,1 # i = i+1
			blt $t2,$s0,while_k # if ( i <= final ){ while }
			jal fim_while
			jr $ra
			
			
	
	contador_menor:	
				
			add $s6,$s6,1 #soma mais um no contador
			addi $t2,$t2,1 # i = i+1
			blt $t2,$s0,while_k # if ( i <= final ){ while } 
			jal fim_while
			jr $ra
	contador_igual:
			
			add $s7,$s7,1# soma mais um no contador 
			addi $t2,$t2,1 # i = i+1
			blt $t2,$s0,while_k # if ( i <= final ){ while } 
			jal fim_while
			jr $ra
	
	
	Somatario_pares: # vai andar pelo vetor somando os valores nas posições pares 
		
		li $t2, 0 #indice do vetor 1 
		li $t4, 0 #aux_posição
		li $t5, 0 #soma 
		
		while_soma:
		
			add $t4,$zero,$t2 # salvar posição 
		
			add $t4,$t4,$t4  # 2i
			add $t4,$t4,$t4   # 4i
			add $t1, $t4, $a1 # combinando os dois componentes do endereco 
		
			lw $t0, 0( $t1 ) # obtendo o valor da celula do array	
			add $t5,$t5,$t0
		
			addi $t2,$t2,2
		
			blt $t2,$s0,while_soma # if ( i < 4 ){ while } 
			
		li $v0,4
		la $a0,msg5 #escrevedo a msg da soma 
		syscall
			
		li $v0,1
		add $a0,$zero,$t5 # escrevendo o resultado da soma
		syscall
			
		jr $ra #retornando o controle para o chamador
		
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a2, 0
		syscall 
		jr $ra #retornando o controle para o chamador
		
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
	sw $s0,32 ($sp)
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
			
			#condição de troca 
			
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
				subi $t2,$s0,1  # $t2 recebe tamano do array - 1
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
			 lw $s0 ,32 ($sp)
			 lw $ra ,36 ($sp)
			 addi $sp,$sp,40 #restaurar o ponteiro da pilha 
			 
			 jr $ra #voltando pra o ponto que chamou a função 
			
			

	
	
	
