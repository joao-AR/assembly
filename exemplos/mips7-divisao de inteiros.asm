.text 
	li $t0,32
	li $t1, 5 
	
	div $t0,$t1
	
	# O resultado da divisao é salvo en hi e lo 
	
	# Parte inteira será salva em $s0
	mflo $s0
	
	#resto em $s1
	mfhi $s1