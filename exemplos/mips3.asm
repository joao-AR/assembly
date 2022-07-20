.data 
	idade: .word 56 #valor interiro na memoria RAM 

.text 
	li $v0,1
	lw $a0,idade
	syscall