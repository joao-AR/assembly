
.data
	msg1: .asciiz "\n Leitura de matriz:\n"
	msg2: .asciiz "\n Numero de linhas: "
	msg3: .asciiz "\n Numero de colunas: "
	msg4: .asciiz "\n mat["
	msg5: .asciiz "]["
	msg6: .asciiz "] = "
	msgLinhasNulas: .asciiz "\n Quantidade de linhas nulas da matriz: "
	msgColunasNulas: .asciiz "\n Quantidade de colunas nulas da matriz: "
		
.text
	main: 
		addi $v0, $zero, 4
		la $a0, msg1
		syscall		
		
		la $a0, msg2
		jal ler_n
		addi $s0, $v0, 0	  #s0 = numero de linhas
		
		la $a0, msg3
		jal ler_n
		addi $s1, $v0, 0    #s1 = numero de colunas
	
		addi $s2, $zero, 4  #s2 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
	
		addi $a0, $s0, 0 
		addi $a1, $s1, 0
		addi $a2, $s2, 0
		
		jal alocar_matriz   
		
		la $s3, ($v0)       #s3 = endereço base da matriz
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		
		jal ler_matriz_int  
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		
		jal imprimir_matriz_int 
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		jal calcular_linhas_colunas_nulas 
		
		addi $s4, $v0, 0
		addi $s5, $v1, 0
		
		la $a0, msgLinhasNulas
		addi $a1, $s4, 0
		jal imprimir_string_seguida_de_inteiro
		
		
		la $a0, msgColunasNulas
		addi $a1, $s5, 0
		jal imprimir_string_seguida_de_inteiro
		
	
	
		###########Finalizando o programa############
		fim_main:
		addi $v0, $zero, 10
		syscall
		
		
	
	
	ler_n: 
	
		
		addi $v0, $zero, 4
		syscall		#"exemplo: Insira um valor para N:"
		
		addi $v0, $zero, 5
		syscall
		
		jr $ra #retornando o controle para o chamador
		
		
	alocar_matriz:
		mult $a0, $a1 
		mflo $a0 	   #a0 = linhas * colunas = numero total de elementos
		
		mult $a0, $a2
		mflo $a0       #a0 = numero total de elementos * tamanho de um elemento = total de bytes da representacao da matriz na memoria.
		
		addi $v0, $zero, 9
		syscall 
		
		jr $ra 
		

	ler_matriz_int: 
	
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)     #ja que vamos chamar um procedimento precisamos salvar o endereço de retorno de "leitura" na pilha.
		
		move $a3, $a0      #a3 = endereço base matriz
		addi $s0, $a1, 0 	 #s0 = numero de linhas
		addi $s1, $a2, 0   #s1 = numero de colunas
		addi $t0, $zero, 0 #i = 0
		addi $t1, $zero, 0 #j = 0
		
		loop_ler_matriz: 
		la $a0, msg4
		li $v0, 4
		syscall # " Insira o valor de Mat["
	    
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
		syscall #lendo o valor de Mat[i][j]
		move $t2, $v0 #t2 = valor
	
		addi $a0, $t0, 0
		addi $a1, $t1, 0
		addi $a2, $s1, 0
		jal calcular_endereco_elemento_matriz 
		sw $t2, 0($v0) #Mat[i][j] = t2
	
		addi $t1, $t1, 1 #j++
		blt $t1, $s1, loop_ler_matriz #if j<ncol
	
		li $t1, 0 # j = 0
		addi $t0, $t0, 1 #i++
		blt $t0, $s0, loop_ler_matriz #if i<nlin
	
		#li $t0, 0 # i = 0
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
		addi $s0, $a1, 0 	 #s0 = numero de linhas
		addi $s1, $a2, 0   #s1 = numero de colunas
		addi $t0, $zero, 0 #i = 0
		addi $t1, $zero, 0 #j = 0	
	
		la $a0, 10 #10 == codigo ASCII para newline ('\n')
		li $v0, 11
		syscall    #"\n"
		
		loop_imprimir_matriz: 
			
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s1, 0		
			jal calcular_endereco_elemento_matriz 
			lw $a0, 0($v0)
			
			li $v0, 1
			syscall    #imprime mat[i][j]
	
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


	calcular_endereco_elemento_matriz: #
	 
		mul $v0, $a0, $a2  # i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $a1  # (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2    # [(i * ncol) + j] * 4(calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a3  #retona a soma do endereço base da matriz ao deslocamento (i.e, return &mat[i][j])
		jr $ra 

		
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra #retornando o controle para o chamador	
		
				
	calcular_linhas_colunas_nulas: 
		subi $sp, $sp, 24
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $ra, 20($sp)
		  
		la $s0, ($a0)  	 #s0 = endereço matriz
		addi $s1, $a1, 0   #s1 = linhas da matriz
		addi $s2, $a2, 0   #s2 = colunas da matriz
		addi $s3, $zero, 0 #Numero de linhas nulas = 0 
		addi $s4, $zero, 0 #Numero de colunas nulas = 0	
		
		addi $t0, $zero, 0 #i = 0
		addi $t1, $zero, 0 #j = 0
		
		loop_calcular_linhas:
			
			loop_i_calcular_linhas:
			addi $t2, $zero, 0 #somaLinha  (t2) = 0  
		
				loop_j_calcular_linhas:
				addi $a0, $t0, 0
				addi $a1, $t1, 0
				addi $a2, $s2, 0 
				la $a3, ($s0)		
				jal calcular_endereco_elemento_matriz 
				lw $t4, 0($v0)	#t4 = mat[i][j]
			
				add $t2, $t2, $t4 #somaLinha  (t2) += mat[i][j] 
				
				inc_j_linhas:
				addi $t1, $t1, 1  	  	#j++
				blt $t1, $s2, loop_j_calcular_linhas #if j<ncol
			
			
			verificar_linha:
			bne $t2, $zero, inc_i_linhas #if(somaLinha == 0)
			add $s3, $s3, 1 				#Numero de linhas nulas++
			
			inc_i_linhas:
			addi $t1, $zero, 0 	  	#j = 0
			addi $t0, $t0, 1  	  	#i++
			blt $t0, $s1, loop_i_calcular_linhas #if i<nlin			
			
			
		loop_calcular_colunas:
			addi $t0, $zero, 0 #i = 0
			
			loop_i_calcular_colunas:
			addi $t3, $zero, 0 #somaColuna (t3) = 0 		
		
				loop_j_calcular_colunas:
				addi $a0, $t1, 0
				addi $a1, $t0, 0
				addi $a2, $s2, 0 
				la $a3, ($s0)		
				jal calcular_endereco_elemento_matriz 
				lw $t4, 0($v0)	#t4 = mat[j][i]
		
				add $t3, $t3, $t4 #somaColuna (t3) += mat[j][i]  
				
				inc_j_colunas:
				addi $t1, $t1, 1  	  		  #j++
				blt $t1, $s1, loop_j_calcular_colunas #if j<nlin
			
			
			verificar_coluna:
			bne $t3, $zero, inc_i_colunas #if(somaColuna == 0)
			add $s4, $s4, 1 		#Numero de colunas nulas++
			
			inc_i_colunas:
			addi $t1, $zero, 0 	  	#j = 0
			addi $t0, $t0, 1  	  	#i++
			blt $t0, $s2, loop_i_calcular_colunas #if i<ncol
			
									
		fim_calcular:
		addi $v0, $s3, 0
		addi $v1, $s4, 0
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24
		jr $ra