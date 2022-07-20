#matriz numeros interios 
.data
	msg1: .asciiz "\nLeitura de matriz 3x3 :\n"
	msg2: .asciiz "\n"
	msg4: .asciiz "\nmat["
	msg5: .asciiz "]["
	msg6: .asciiz "] = "
	msg_soma_diagonal_secundaria: .asciiz "Soma da diagonal secundaria: "
	teste: .asciiz "teste"
	
.text
	main: 
		
		#--------------variaveis--------------#
		
		li $t4,0 # vai receber a soma de i + j de todos elementos da matriz
		li $t5,2 # i+j = 2 é diagonal secundaria  
		li $t6,0 # soma da diagonal secundaria 
		
		#--------comecando o programa--------#
		
		li $v0,4
		la $a0, msg1
		syscall		
		
		li $s0,3 # vai ler uma matriz 3x3
	
		addi $s2, $zero, 4 #s2 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
	
		addi $a0, $s0, 0 
		addi $a2, $s2, 0
		jal alocar_matriz   
		la $s3, ($v0) #s3 = endereço base da matriz
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		jal ler_matriz_int
		#---------- Imprimindo a soma da diagonal secundaria ----------#
		li $v0,4
		la $a0,msg_soma_diagonal_secundaria
		syscall
		
		li $v0,1
		add $a0,$zero,$t6
		syscall
		
		#---------- Imprimindo a matriz ----------#
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		jal imprimir_matriz_int #(matriz:address, linhas:int, colunas:int):void
	
		#-------Finalizando o programa ----------#
		fim_main:
		addi $v0, $zero, 10
		syscall
		
		
	
	ler_n: 
		li $v0,4 #imprimindo a msg passada
		syscall 
		li $v0,5 #lendo o valor int 
		syscall
		jr $ra 
		
		
	alocar_matriz:
	
		mult $a0, $a0 #calculando o total de elementos 
		mflo $a0 #a0 = (linhas * colunas) = numero total de elementos
		
		mult $a0, $a2 # calculando o total de bytes para a memoria 
		mflo $a0 #a0 = (numero total de elementos * tamanho de um elemento) = total de bytes da representacao da matriz na memoria.
		
		li $v0,9
		syscall #aloca a0 bytes e guarda o endereço do inicio do bloco em v0.
		
		jr $ra #retornando o controle para o chamador	
		

	ler_matriz_int: 
	
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)
		
		move $a3, $a0      #a3 = endereço base matriz
		addi $s0, $a1,0   #s0 = numero de linhas
		addi $s1, $a1,0   #s1 = numero de colunas
		addi $t0, $zero,0 #i = 0
		addi $t1, $zero,0 #j = 0
		
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
		
		add $t4,$t1,$t0 # somando i + j
		
		beq $t4,$t5,add_diagonal_secundaria # if ( (i+j) == (n+1) )
		
		addi $t1, $t1, 1 #j++
		blt $t1, $s1, loop_ler_matriz 
	
		li $t1, 0 # j = 0
		addi $t0, $t0, 1 #i++
		blt $t0, $s0, loop_ler_matriz 
	
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		lw $ra, 8($sp) 
		addi $sp, $sp, 12
		jr $ra

add_diagonal_secundaria:
	add $t6,$t6,$t2
	
	#li $v0,4
	#la $a0,teste
	#syscall
	
	addi $t1, $t1, 1 #j++
	blt $t1, $s1, loop_ler_matriz 
	
	li $t1, 0 # j = 0
	addi $t0, $t0, 1 #i++
	blt $t0, $s0, loop_ler_matriz 
	
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	lw $ra, 8($sp) 
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
	
		la $a0, 10 
		li $v0, 11
		syscall#"\n"
		
		loop_imprimir_matriz: 
			
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s1, 0		
			jal calcular_endereco_elemento_matriz 
			lw $a0, 0($v0)
			
			li $v0, 1
			syscall    #imprime mat[i][j]
	
			la $a0, 32 
			li $v0, 11
			syscall    
	
			addi $t1, $t1, 1 #j++
			blt $t1, $s1, loop_imprimir_matriz
 	
			la $a0, 10 
			syscall    #"\n"
	
			li $t1, 0 #j = 0
			addi $t0, $t0, 1 #i++
			blt $t0, $s0, loop_imprimir_matriz 
			li $t0, 0 #i = 0
	 
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $ra, 8($sp) 
			addi $sp, $sp, 12
			jr $ra


	calcular_endereco_elemento_matriz: #calcula o endereço do elemento mat[i][j]
	 
		mul $v0, $a0, $a2  # i * n col (calcula a posicao do inicio da linha i)
		add $v0, $v0, $a1  # (i * n col) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2    # [(i * n col) + j] * 4(calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a3  #retona a soma do endereço base da matriz ao deslocamento (i.e, return &mat[i][j])
		jr $ra 

		
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )
		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra 	
		
				
	
