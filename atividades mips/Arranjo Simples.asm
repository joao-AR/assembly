.data
	msg: .asciiz "Digite n: "
	msg2: .asciiz "Digite p: "
	msg3: .asciiz "valor do arranjo: "
	zero: .float 0.0
.text

	#imprimindo menssagem para o usuario
	li $v0,4
	la $a0,msg
	syscall
	
	#lendo n
	li $v0,5 
	syscall 
	
	add $s0,$zero,$v0 #salvando valor lido e $s0
	add $s3,$zero,$v0 #salvando para contas futuras
	
	jal Fatorial #n!
	add $s4,$zero,$s5 #salvando valor de n! em $s4

	li $v0,4
	la $a0,msg2
	syscall
	
	#lendo p
	li $v0,5 
	syscall
	
	add $s1,$zero,$v0 #salvando valor lido e $s1

	sub $s0,$s3,$s1 #(n - p) 
	
	jal Fatorial #(n-p)!
	
	div $s4,$s5 # n! / (n-p)!
	
	li $v0,4
	la $a0,msg3
	syscall
	
	mflo $a0
	
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	

Fatorial: 
	add $t0,$zero,$s0 # $t0 recebe o valor do numero pessado pelo usuario
	add $t0,$t0,-1
	
	add $s5,$zero,$s0 # valor do fatorial
	
	
	while_fatorial:

		mult $s5,$t0
		mflo $s5
		add $t0,$t0,-1
		
	bgtz $t0,while_fatorial
	
jr $ra
		
	
		
		
	

	
