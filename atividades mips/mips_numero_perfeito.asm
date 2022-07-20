# Esse programa verifica se um numero é perfeito
.data
	msg1: .asciiz "Digite um nunero: "
	msg2: "\nÉ um numero perfeito\n"
	msg3: "\nNão é  um numero pereito\n"

.text

	li $v0,4
	la $a0,msg1 #  Digite um nunero: 
	syscall
	
	li $v0,5  # lendo o numero 
	syscall
	
	add $s0,$zero,$v0 # passando para $s0 o valor do input
	
	li $t1,1 # começo divisores	
	li $s2,0 # Resultado da soma
	
	j while_divisores # chamada da função para calcular a soma dos divisores
	
	
	
while_divisores: 
	
	div $s0,$t1 # dividir o valor passado pelo valor atual
	mfhi $s1 # $s1 recebe resto da divisão n/divisor positivo 
	
	beqz $s1, soma_divisores # Se valor passado / valor atual = 0 ($s1 = 0) quer dizer que o numero é divisiver
	
	add $t1,$t1,1 # somando mais um para ir para o proximo valor de divisor
	
	blt $t1,$s0,while_divisores # enquanto o valor do divisor for menor que N vamos ficar no loop
	
	beq $s2,$s0,simP # se valor da soma = valor N é chama a função sim perfeito
	
	li $v0,4
	la $a0,msg3 # Não é  um numero pereito
	syscall
	
	li $v0,10 # encerra o programa
	syscall
jr $ra

soma_divisores: 
	add $s2,$s2,$t1 # valor divisor = valor divisor + divisor atual 
	
	add $t1,$t1,1 # somando mais um
	blt $t1,$s0,while_divisores # enquanto o valor do divisor for menor que N vamos ficar no loop
jr $ra

simP:
	li $v0,4
	la $a0,msg2 # É um numero perfeito
	syscall
	
	li $v0,10
	syscall

	