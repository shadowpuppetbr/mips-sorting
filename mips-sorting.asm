.data
vetorPadrao: 12,43,65,32,76,12,23,76,67,23,98,32,1,4,68, 95,44,15,46,23,76,6,88,2,37,0,99,13,65,29,74,82,33,50
novalinha:      .asciiz "\n"
s_escolhe_algo: .asciiz "Esse programa ordena um vetor de números usando os algoritmos: \n\n(1) Bubble Sort \n(2) Selection Sort \n(3) Insertion Sort\n\n Escolha qual algorimo usar!"
string2:        .asciiz "Certo! Agora de que maneira quer inserir os dados para serem ordenados?\n(1) digitando manualmente\n(2) valor padrão\n"
string3:        .asciiz "O vetor é: "
string4:        .asciiz "A novo vetor ordenado é: "
string5:        .asciiz "Ok, você quer executar novamente o programa(1) ou quer encerrar(0)?\n"
string6:        .asciiz "O tamanho do vetor é de?\n"
string7:        .asciiz "Digite o vetor:\n"
vetor:          .word  1

.text
main:
#               MENUS

li              $v0, 4         # imprime string 1
la              $a0, s_escolhe_algo
syscall

li              $v0, 5         # Lê qual o algoritmo e armazena em S0
syscall
move            $s0, $v0

li              $v0, 4         # imprime string 2
la              $a0, string2
syscall

li              $v0, 5         # Lê qual a forma de input e armazena em S1
syscall
move            $s1, $v0

li              $t1, 1		# $t1 = 1
li              $t2, 2		# $t1 = 2
li              $t3, 3		# $t1 = 3
beq		$s1, $t1, preenche_vetor	# if $s1 == $t1 then goto target

choose_algoritmo:
#               parte que executa o algoritmo selecionado

beq		$s0, $t1, call_buble	# se $s0 == 1 executar buble sort
beq		$s0, $t2, call_sel	    # se $s0 == 2 executar selection sort
beq		$s0, $t3, call_insert	# se $s0 == 3 executar Insertion sort

j               main            # digitou errado? volte para o começo

call_buble:     jal buble_sort
j               posfacio

call_sel:       jal selection_sort
j               posfacio

call_insert:    jal             insertion_sort
j               posfacio

#               #########################################

posfacio:
li              $v0, 4         # imprime string 5
la              $a0, string5
syscall

li              $v0, 5         # Lê se quer voltar a executar o programa
syscall
bne		$v0, $zero, main	   # if $v0 == $zero then goto SAIR


sair:           # finaliza o programa
li              $v0, 10
syscall


preenche_vetor: # preenche o vetor digitando manualmente

li              $v0, 4         # imprime string 6
la              $a0, string6
syscall

li              $v0, 5         # Lê qual o tamaho do vetor a ser digitado
syscall
move            $t1, $v0

li              $v0, 4         # imprime string 7
la              $a0, string7
syscall

la              $t0, vetor		# pega o endereço do vetor para preencher

preenche_loop:

li              $v0, 5          # Leio o valor
syscall
move            $t2, $v0        # armazena em T2
sw              $t2, ($t0)		# armazeno o valor no endereço do vetor
addi	        $t0, $t0, 4		# $t0 = $t0 + 4  soma no endereço
addi	        $t1, $t1, -1	# $v0 = $v0 - 1 diminui no contador do tamanho do vetor

bne     $t1, $zero, preenche_loop	# if $v0 != $zero then goto preenche_loop

j               choose_algoritmo


#               [ ] TODO - Implementar os algoritmos hehe

buble_sort:

jr              $ra					# jump to $ra


selection_sort:

jr              $ra					# jump to $ra



insertion_sort:

jr              $ra					# jump to $ra

