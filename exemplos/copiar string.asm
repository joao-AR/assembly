.data 
	mensagem: .asciiz " Digite string: "
	string: .space 50
	string2: .space 50
	string3: .space 100
	mensagemsaida: .asciiz "copia da string: "
	nada: .asciiz ""
	
.text

	li $v0,4
	la $a0,mensagem
	syscall
	
	li $v0,8
	la $a0,string
	la $a1,50
	syscall
	
	move $s1,$a0 # $s1 = string 1
	
	li $v0,4
	la $a0,mensagem
	syscall 
	
	li $v0,8
	la $a0,string2
	la $a1,50
	syscall 
	
	move $s2,$a0 # $s2 = string 2
	
	
	#la $a0,nada
	la $a0,string3
	
	#escreve o resultado 
	
	jal strcpy
	
	li $v0,4
	la $a0,mensagemsaida
	syscall
	
	li $v0,4
	la $a0,string3
	syscall
	
	li $v0,10
	syscall
	
	
	strcpy:
		sub $sp,$sp,4
		sw $s0, 0($sp)
		
		add $s0,$zero,$zero # i
		
		L1:
			add $t1,$s1,$s0 # t1 = string + i
			
			lb $t2,0($t1) # $t2 recebe um caractere 
			
			add $t3,$a0,$s0 # $t3 = "" + i 
			
			sb $t2,0($t3) # salvando caractere
			
			beq $t2,$zero,L2 # se $t2 = 0 = final da string
			
			add $s0,$s0,1 # i++
			
			j L1
			
		L2:
			lw $s0,0($sp)
			add $sp,$sp,4
			jr $ra
			
			
			
			
	