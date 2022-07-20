#Esse programa pega um vetor e o ordena em forma crescente

.data 
	valores: 5,4,3,7
	
.text 
	# argumentos da função 
	li $a0,3	#tamanho do array
	la $a1,valores  #endereço do primeiro elemento do array
	
	jal bubble_sort


end: 
	li $v0,10
	syscall
	

bubble_sort:
	
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
			
			
	
	
