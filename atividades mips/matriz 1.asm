
.data
	msg1: .asciiz "\nLeitura de matriz:\n"
	msg2: .asciiz "\nNumero de linhas: "
	msg3: .asciiz "\nNumero de colunas/tamanho do vetor: "
	msg4: .asciiz "\nmat["
	msg5: .asciiz "]["
	msg6: .asciiz "] = "
	msg7: .asciiz "\nLeitura de vetor:\n"
	msg8: .asciiz "\nvet["
	msg9: .asciiz "\n\nResultado:\n\n"
	times: .asciiz "\nx\n"
	equals: .asciiz "\n=\n"
	
.text
	main: 
		addi $v0, $zero, 4
		la $a0, msg1
		syscall		
	
		addi $s0, $zero, 4
		addi $s1, $zero, 3
	
		addi $s2, $zero, 4  #s2 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
	
		addi $a0, $s0, 0 
		addi $a1, $s1, 0
		addi $a2, $s2, 0
		
		jal alocar_matriz   
		
		la $s3, ($v0) #s3 = endereço da matriz
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		
		jal ler_matriz_int # le uma matriz de inteiros 
		
		addi $a0, $s1, 0
		addi $a1, $s2, 0
		jal alocar_vetor   
		la $s4, ($v0)       #s4 = endereço do vetor
		
		addi $a0, $s4, 0
		addi $a1, $s1, 0
		jal ler_vetor_int   # le um vetor de int 


		#Produto matriz-vetor: A(mxn) x V(nx1) = B(mx1)
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		addi $a3, $s4, 0
		
		jal multiplica_matriz_vetor 
		la $s5, 0($v0) # s5 = endereço do vetor resultado
		
		# imprimindo resultado
		la $a0, msg9
		addi $v0, $zero, 4 
		syscall
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		jal imprimir_matriz_int 
		
		addi $v0, $zero, 4 
		la $a0, times
		syscall	
		
		addi $a0, $s4, 0
		addi $a1, $s1, 0 
		addi $a2, $zero, 1
		jal imprimir_matriz_int 
		
		addi $v0, $zero, 4 
		la $a0, equals
		syscall			
		
		addi $a0, $s5, 0
		addi $a1, $s0, 0 
		addi $a2, $zero, 1
		jal imprimir_matriz_int 
		
		
		###Finaliza programa###
		li $v0, 10
		syscall 
	
	
	
	ler_n: 
		
		addi $v0, $zero, 4
		syscall	
	
		addi $v0, $zero, 5
		syscall
		
		jr $ra 
		
		
	alocar_matriz:
	
		
		mult $a0, $a1 
		mflo $a0 	   
		
		mult $a0, $a2
		mflo $a0       	#a0 = numero total de elementos * tamanho de um elemento 
				#  =
				# total de bytes da representacao da matriz na memoria.
		
		addi $v0, $zero, 9
		syscall 
		
		jr $ra	
		

	ler_matriz_int: 
	
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)   
		
		move $a3, $a0 #a3 = endereço da matriz
		addi $s0, $a1, 0 #s0 = numero de linhas
		addi $s1, $a2, 0 #s1 = numero de colunas
		addi $t0, $zero, 0 #i = 0
		addi $t1, $zero, 0 #j = 0
		
		loop_ler_matriz: 
		la $a0, msg4
		li $v0, 4
		syscall 
	    
            move $a0, $t0
		li $v0, 1
		syscall # i
	
		la $a0, msg5
		li $v0, 4
		syscall #"]["
	
		move $a0, $t1
		li $v0, 1
		syscall # j
	
		la $a0, msg6
		li $v0, 4
		syscall # "]: "
	
		li $v0, 5
		syscall 
		move $t2, $v0 #t2 = valor
	
		addi $a0, $t0, 0
		addi $a1, $t1, 0
		addi $a2, $s1, 0
		jal calcular_endereco_elemento_matriz 
		sw $t2, 0($v0) 
	
		addi $t1, $t1, 1 #j++
		blt $t1, $s1, loop_ler_matriz #if j<ncol
	
		li $t1, 0 # j = 0
		addi $t0, $t0, 1 #i++
		blt $t0, $s0, loop_ler_matriz #if i<nlin

		sw $s0, 0($sp)
		sw $s1, 4($sp)
		lw $ra, 8($sp) #recuperando o endereço de retorno para a main
		addi $sp, $sp, 12
		jr $ra


	imprimir_matriz_int: 
	
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)
		
		move $a3, $a0      #a3 = endereço base matriz
		addi $s0, $a1, 0   #s0 = numero de linhas
		addi $s1, $a2, 0   #s1 = numero de colunas
		addi $t0, $zero, 0 #i = 0
		addi $t1, $zero, 0 #j = 0	
	
		loop_imprimir_matriz: 
			
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s1, 0		
			jal calcular_endereco_elemento_matriz 
			lw $a0, 0($v0)
			
			li $v0, 1
			syscall    
	
			la $a0, 32 #32 == codigo ASCII para white space
			li $v0, 11
			syscall    #" "
	
			addi $t1, $t1, 1 #j++
			blt $t1, $s1, loop_imprimir_matriz #if j<ncol 
 	
			la $a0, 10 #10 == codigo ASCII para newline ('\n')
			syscall    #"\n"
	
			li $t1, 0 #j = 0
			addi $t0, $t0, 1 #i++
			blt $t0, $s0, loop_imprimir_matriz #if i<nlin
			li $t0, 0 #i = 0
	 
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $ra, 8($sp) #recuperando o endereço de retorno para a main
			addi $sp, $sp, 12
			jr $ra


	calcular_endereco_elemento_matriz: 
	 
		mul $v0, $a0, $a2  # i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $a1  # (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2    # [(i * ncol) + j] * 4(calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a3  #retona a soma do endereço base da matriz ao deslocamento (i.e, return &mat[i][j])
		jr $ra 
	

	alocar_vetor:
		
		mult $a0, $a1 
		mflo $a0 #a0 = tamanhoVetor * tamanhoElemento = total de bytes do vetor
		
		addi $v0, $zero, 9
		syscall #
		
		jr $ra 
		
	
	ler_vetor_int: 
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
					 	  
		add $s0, $a1, $zero   #guardar o tamanho do vetor em $s0
		la $s1, ($a0)         # endereço base do vetor
		add $s2, $zero, $zero # i = 0 
		
		addi $v0, $zero, 4
		la $a0, msg7
		syscall	# imprimir: Leitura de Vetor:
		
		leitura:
			sll $t0, $s2, 2 # t0 = 4 * i (i.e, deslocamento)
			add $t0, $t0, $s1 # t0 = deslocamento + endereço base do vetor (t0 == &vetor[i])
			
			addi $v0, $zero, 4
			la $a0, msg8
			syscall  #imprimir: vetor[
			
			addi $v0, $zero, 1
			add $a0, $zero, $s2
			syscall  #imprimir: i
			
			addi $v0, $zero, 4
			la $a0, msg6
			syscall   #imprimir: ] = 
			
			addi $v0, $zero, 5
			syscall	# ler: vetor[i]
			sw $v0, 0($t0) #guardar o valor lido em vetor[i]
			
			addi $s2, $s2, 1 # i++
			bne $s2, $s0, leitura # while(i < numero de elementos do vetor)
		
		lw $s0, 0($sp)  #guardando os valores originais de volta em s0/s1/s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12 #desempilhando s0/s1/s2  
		jr $ra 
		
		
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra 	
		
		
	multiplica_matriz_vetor: 
		
		addi $sp, $sp, -24 
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $ra, 20($sp)
		
		la $s0, ($a0)        #s0 = endereço base matriz
		la $s1, ($a3)	  	 #s1 = endereço base vetor
		addi $s2, $a1, 0     #s2 = linhas da matriz / tamanho do vetor resultado
		addi $s3, $a2, 0     #s3 = colunas da matriz / tamanho do vetor
		
		addi $a0, $s2, 0
		addi $a1, $zero, 4
		jal alocar_vetor    
		la $s4, ($v0)
		
		addi $t0, $zero, 0  #t0(i) = 0
		addi $t1, $zero, 0  #t1(j) = 0
		
			loop_mult_i:
			addi $t2, $zero, 0  #t2 (soma) = 0
			
			loop_mult_j:
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s3, 0 
			la $a3, ($s0)		
			jal calcular_endereco_elemento_matriz 
			lw $t3, 0($v0)	#t3 = mat[i][j]
			
			sll $t4, $t1, 2   #t4 = j * 4 (i.e, deslocamento)
			add $t4, $t4, $s1 #t4 = &vet[j]
			lw $t5, 0($t4)    #t5 = vet[j]
			
			mult $t3, $t5
			mflo $t5		#t5 = mat[i][j] * vet[j]
			
			add $t2, $t2, $t5 #t2 (soma) += mat[i][j] * vet[j]
			
			addi $t1, $t1, 1  	  #j++
			blt $t1, $s3, loop_mult_j   #if j<ncol, goto loop_mult_j
 	
 	
 			sll $t4, $t0, 2   #t4 = i * 4 (i.e, deslocamento)
			add $t4, $t4, $s4 #t4 = &vetResultado[i]
			sw $t2, 0($t4)    #vetResultado[i] = soma
 	
			addi $t1, $zero, 0 	  #j = 0
			addi $t0, $t0, 1  	  #i++
			blt $t0, $s2, loop_mult_i   #if i<nlin

		la $v0, ($s4)
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24 			
		jr $ra 