.data 
	meuArray: .word 1,2,3,4,5,6,7,8,9,10
	msg: .asciiz "Array = "
	msg2: .asciiz "O desvio padrao e de: "
	zero: .float  0.0
	dez: .float 10
.text
	move $t0,$zero #indice do array
	move $t1, $zero #valor a ser colocado no array 
	li $t2,40
	move $t0,$zero
	
	lwc1 $f10,dez # tamanho do vetor (quantidade de elementos)
	li  $s0,0 #valor soma media
	lwc1 $f6,zero #valor soma desvio
	
	jal media
	move $t0,$zero #indice do array ( voltando para 0)
	jal variancia
	
	li $v0,4
	la $a0,msg
	syscall
	
	move $t0,$zero #indice do array(voltando para 0)
	jal imprime
	
	li $v0,4
	la $a0,msg2
	syscall 
	
	sqrt.s $f18,$f16 # recebe a raiz quadrada de ($f16 = variancia) = Desvio padrão 
	
	#imprimindo o desvio padrão 
	lwc1 $f1,zero
	add.s $f12,$f18,$f0
	li $v0,2
	syscall
	
	#finalizando o programa
	li $v0,10
	syscall
	
	imprime: 
		#beq $t0,$t2,saiDaImpressao
		li $v0,1
		lw $a0,meuArray($t0)
		syscall
		addi $t0,$t0,4
		blt $t0,$t2,imprime
	jr $ra
	
	media: 
		lw $t3,meuArray($t0)
		add $s0,$s0,$t3
		addi $t0,$t0,4 # indo para o proximo elemento
		blt $t0,$t2,media
		
		mtc1 $s0,$f2
		cvt.s.w $f2,$f2
		#add.s $f2,zero,$f0
		
		div.s $f0,$f2,$f10 # $f0 = valor da media 
	jr $ra
	
	variancia:
	#media aritimetica dos quadrados dos desvios 
		
		lw $t3,meuArray($t0)
		addi $t0,$t0,4
		
		mtc1 $t3,$f4 #vovendo $t3 para $f4
		cvt.s.w $f4,$f4 #convertendo $f4  para de word para float
		
		sub.s $f8,$f0,$f4 # media - valor do array (desvio)
		mul.s $f6,$f8,$f8 # (Desvio)²
		add.s $f14,$f14,$f6 # soma dos (desvios)²
		
		blt $t0,$t2,variancia
	
		div.s $f16,$f14,$f10 # somatorio das somas dos devios/ 10 = Variancaia = $f16
	jr $ra
	
	
	
	
	
	
	
	
	