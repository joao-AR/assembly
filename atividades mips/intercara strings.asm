# João pedro Alves Rodrigues 
.data 
	ent1: .asciiz " Insira a string 1: "
	ent2: .asciiz " Insira a string 2: "
	
	str1: .space 100
	str2: .space 100
	str3: .space 200
	msg_intercala: .asciiz "string intercalada: "
	
.text
	
	li $v0,4
	la $a0,ent1
	syscall
	
	li $v0,8
	la $a0,str1
	la $a1,50
	syscall
	
	move $s1,$a0 # $s1 = string 1
	
	li $v0,4
	la $a0,ent2
	syscall 
	
	li $v0,8
	la $a0,str2
	la $a1,50
	syscall 
	
	move $s2,$a0 # $s2 = string 2
	
	la $a0,str3 # $a0 = string t3 vazia 
	
	#escreve o resultado 
	
	jal intercala
	
	li $v0,4
	la $a0,msg_intercala
	syscall
	
	li $v0,4
	la $a0,str3
	syscall
	
	li $v0,10
	syscall
	
	
	intercala:
		sub $sp,$sp,4
		sw $s0, 0($sp)
		
		add $s0,$zero,$zero # i contador das outras string
		add $s4,$zero,$zero # j contador da string 3
		
		while_intercala:
			add $t1,$s1,$s0 # t1 = string + i
			add $t2, $s2,$s0 # t2 = string 2 +i
			
			lb $t3,0($t1) # $t3 recebe um caractere 
			lb $t4,0($t2) # $t4 recebe um caractere 
			
			add $t5,$a0,$s4 # $t5 = "" + i 
			sb $t3,0($t5) # salvando caractere
			
			add $s4,$s4,1 # j++
			
			add $t5,$a0,$s4 # $t5 = "" + i 
			sb $t4,0($t5) # salvando caractere
			
			add $s4,$s4,1 # j++
			add $s0,$s0,1 # i++
			
			beq $t3,$t4,verifica_fim # vendo se o caractere da string1 = string2
			
			j while_intercala
			
			
		verifica_fim: 
			beqz $t3,fim_while_intercala
			j while_intercala
			
		fim_while_intercala:
			lw $s0,0($sp)
			add $sp,$sp,4
			jr $ra
			