#Esse programa obtem um valor de uma posição do arrua c e soma com $s1 = 30
.data
c: .word 3, 0, 1, 2, -6, -2, 4, 10, 3, 7, 8, -9, -15, -20, -87, 0

.text
li $s1, 30               # determinando o valor para $s1
la $s2, c                # colocando o endereco do array em $s2
li $t2, 2                # colocando o indice do array em $t2

add $t2, $t2, $t2        # 2i
add $t2, $t2, $t2        # 4i

add $t1, $t2, $s2        # combinando os dois componentes do endereco
lw $t0, 0 ( $t1 )        # obtendo o valor da celula do array
add $s0, $s1, $t0        # executando a soma
