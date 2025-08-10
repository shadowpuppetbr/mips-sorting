# Gustavo dos Santos Leon e Gustavo Kopereck
.data
vetorPadrao:     12,43,65,32,76, 12, 23, 76, 67, 23, 98, 32, 1, 4, 68, 95, 44, 15, 46, 23, 76, 6, 88, 2, 37, 0, 99, 13, 65, 29, 74, 82, 33, 50
novalinha:      .asciiz "\n"
espaco:         .asciiz " "
s_escolhe_algo: .asciiz "Esse programa ordena um vetor de números usando os algoritmos: \n\n(1) Bubble Sort \n(2) Selection Sort \n(3) Insertion Sort\n\n Escolha qual algorimo usar!"
string2:        .asciiz "Certo! Agora de que maneira quer inserir os dados para serem ordenados?\n(1) digitando manualmente\n(2) valor padrão\n"
string3:        .asciiz "\nO vetor é: "
string4:        .asciiz "O novo vetor ordenado é: "
instrucoes:     .asciiz "Total de instruções: "
string5:        .asciiz "\nOk, você quer executar novamente o programa(1) ou quer encerrar(0)?\n"
string6:        .asciiz "O tamanho do vetor é de?\n"
string7:        .asciiz "Digite o vetor:\n"
vetor:          .word   1

.text
main:
    # MENUS

    li      $v0,                    4                                               # imprime string 1
    la      $a0,                    s_escolhe_algo
    syscall

    li      $v0,                    5                                               # Lê qual o algoritmo e armazena em S0
    syscall
    move    $s0,                    $v0

    li      $v0,                    4                                               # imprime string 2
    la      $a0,                    string2
    syscall

    li      $v0,                    5                                               # Lê qual a forma de input e armazena em S1
    syscall
    move    $s1,                    $v0

    li      $a2,                    0                                               # contador de instruções
    li      $t1,                    1                                               # $t1 = 1
    li      $t2,                    2                                               # $t2 = 2
    li      $t3,                    3                                               # $t3 = 3
    beq     $s1,                    $t1,                    preenche_vetor          # if $s1 == $t1 then goto target

choose_algoritmo:

    li      $t1,                    1
    beq     $s1,                    $t1,                    subrotina
    jal     vetor_padrao                                                            # se escolheu o vetor padrao, o programa escreve o vetor padrao no mesmo espaco do vetor digitado, para nao ordenar o proprio vetor padrao

subrotina:

    la      $a0,                    string3
    li      $v0,                    4
    syscall

    la      $a0,                    vetor
    jal     print_vetor


    beq     $s0,                    $t1,                    call_bubble             # se $s0 == 1 executar buble sort
    beq     $s0,                    $t2,                    call_sel                # se $s0 == 2 executar selection sort
    beq     $s0,                    $t3,                    call_insert             # se $s0 == 3 executar Insertion sort

    j       main                                                                    # digitou errado? volte para o começo

call_bubble:        jal     bubble_sort
    j       posfacio

call_sel:           jal     selection_sort
    j       posfacio

call_insert:        jal     insertion_sort
    j       posfacio



posfacio:
    move    $t9,                    $a0                                             # salva o endereço do vetor usado, se foi o padrao ou o digitado

    li      $v0,                    4
    la      $a0,                    string4
    syscall

    move    $a0,                    $t9
    jal     print_vetor

    li      $v0,                    4
    la      $a0,                    instrucoes
    syscall
    li      $v0,                    1
    move    $a0,                    $a2
    syscall

    li      $v0,                    4                                               # imprime string 5
    la      $a0,                    string5
    syscall



    li      $v0,                    5                                               # Lê se quer voltar a executar o programa
    syscall
    bne     $v0,                    $zero,                  main                    # if $v0 == $zero then goto SAIR


sair:                                                                               # finaliza o programa
    li      $v0,                    10
    syscall


preenche_vetor:                                                                     # preenche o vetor digitando manualmente

    li      $v0,                    4                                               # imprime string 6
    la      $a0,                    string6
    syscall

    li      $v0,                    5                                               # Lê qual o tamaho do vetor a ser digitado
    syscall
    move    $t1,                    $v0
    move    $a1,                    $t1                                             # $a1 como registrador padrão pro tamanho do vetor

    li      $v0,                    4                                               # imprime string 7
    la      $a0,                    string7
    syscall

    la      $t0,                    vetor                                           # pega o endereço do vetor para preencher

preenche_loop:

    li      $v0,                    5                                               # Leio o valor
    syscall
    move    $t2,                    $v0                                             # armazena em T2
    sw      $t2,                    ($t0)                                           # armazeno o valor no endereço do vetor
    addi    $t0,                    $t0,                    4                       # $t0 = $t0 + 4  soma no endereço
    addi    $t1,                    $t1,                    -1                      # $v0 = $v0 - 1 diminui no contador do tamanho do vetor

    bne     $t1,                    $zero,                  preenche_loop           # if $v0 != $zero then goto preenche_loop

    j       choose_algoritmo



bubble_sort:


    move    $t6,                    $a0                                             # $s0 = endereço base do vetor
    move    $t7,                    $a1                                             # $s1 = tamanho do vetor

    addi    $t8,                    $t7,                    -1                      # $s2 = n-1, número de passagens

loop_externo_bubble:
    li      $t0,                    0                                               # i = 0
    move    $t1,                    $t8                                             # limite da iteração
    addi    $a2,                    $a2,                    2

loop_interno_bubble:
    bge     $t0,                    $t1,                    proximo_loop_externo

    sll     $t2,                    $t0,                    2
    add     $t3,                    $t6,                    $t2                     # $t3 = &vetor[i]
    lw      $t4,                    0($t3)                                          # $t4 = vetor[i]
    lw      $t5,                    4($t3)                                          # $t5 = vetor[i+1]

    ble     $t4,                    $t5,                    sem_troca               # se vetor[i] <= vetor[i+1], não troca

    #  troca vetor[i] e vetor[i+1]
    sw      $t5,                    0($t3)
    sw      $t4,                    4($t3)
    addi    $a2,                    $a2,                    2                       # se nao pulou para sem_troca, ele conta 2 instrucoes a mais

sem_troca:
    addi    $t0,                    $t0,                    1                       # i++
    addi    $a2,                    $a2,                    8                       # conta o total de instrucoes do loop interno
    j       loop_interno_bubble

proximo_loop_externo:
    addi    $t8,                    $t8,                    -1
    bgtz    $t8,                    loop_externo_bubble                             # enquanto s2 > 0, continue
    addi    $a2,                    $a2,                    2

    jr      $ra                                                                     #jump to $ra




selection_sort:

    move    $s0,                    $a0                                             # $s0 endereço do vetor
    move    $s1,                    $a1                                             # $s1 tamanho do vetor
    li      $t5,                    0                                               # Assume T5 como o menor valor do vetor min
    li      $t6,                    0                                               # Assume T6 como indice do loop externo ex. i
    li      $t7,                    0                                               # Assume T7 como indice do loop interno ex. j

loop_externo_selection:
    bge     $t6,                    $s1,                    fim                     # if $t6 i >= tam -1 $t9 then goto fim

    move    $t5,                    $t6                                             # min = i

    move    $t7,                    $t5
    addi    $a2,                    $a2,                    3
loop_interno_selection:
    bge     $t7,                    $s1,                    skip_lis                # if $t7 j >= tam $s1 then goto skip_lis

    move    $t0,                    $t7                                             # t0 = j
    sll     $t0,                    $t0,                    2                       # $t0 = $t0 << 2 multiplica por 4
    add     $t0,                    $s0,                    $t0                     # soma para ter o endereço do vetor[j]
    lw      $t1,                    0($t0)                                          # pega o valor do vetor[j]

    move    $t0,                    $t5                                             # t0 = min
    sll     $t0,                    $t0,                    2                       # $t0 = $t0 << 2 multiplica por 4
    add     $t0,                    $s0,                    $t0                     # soma para ter o endereço do vetor[min]
    lw      $t2,                    0($t0)                                          # pega o valor do vetor[min]

    bge     $t1,                    $t2,                    skip_atualiza_min       # if $t0 num[min] >=num[j] $t1 then goto skip_atualiza_min
    move    $t5,                    $t7                                             # min (t5) = j (t7) atualiza min
    addi    $a2,                    $a2,                    1

skip_atualiza_min:
    addi    $t7,                    $t7,                    1                       # j++
    addi    $a2,                    $a2,                    9
    j       loop_interno_selection

skip_lis:                                                                           # skip loop interno
    beq     $t6,                    $t5,                    skip_swap               # if $t6 == $t5 then goto skip_swap

    move    $t0,                    $t6                                             # t0 = i
    sll     $t0,                    $t0,                    2                       # $t0 = $t0 << 2 multiplica por 4
    add     $t0,                    $s0,                    $t0                     # soma para ter o endereço do vetor[i]
    lw      $t1,                    0($t0)                                          # pega o valor do vetor[i]

    move    $t3,                    $t5                                             # t3 = min
    sll     $t3,                    $t3,                    2                       # $t0 = $t0 << 2 multiplica por 4
    add     $t3,                    $s0,                    $t3                     # soma para ter o endereço do vetor[min]
    lw      $t2,                    0($t3)                                          # pega o valor do vetor[min]

    sw      $t2,                    ($t0)                                           # num[i] = num[min]
    sw      $t1,                    0($t3)                                          # num[min] = num[i]
    addi    $a2,                    $a2,                    10

skip_swap:
    addi    $t6,                    $t6,                    1
    addi    $a2,                    $a2,                    1
    j       loop_externo_selection



insertion_sort:

    move    $s0,                    $a0                                             # $s0 = endereço base do vetor
    move    $s1,                    $a1                                             # $s1 = tamanho do vetor

    li      $s2,                    1                                               # i = 1

loop_externo_insertion:
    bge     $s2,                    $s1,                    fim                     # se i >= n, fim

    sll     $t0,                    $s2,                    2
    add     $t1,                    $s0,                    $t0
    lw      $s3,                    0($t1)                                          # chave = vetor[i]

    addi    $s4,                    $s2,                    -1                      # j = i - 1
    addi    $a2,                    $a2,                    5

while_insertion:
    bltz    $s4,                    insert                                          # if (j >= 0)

    sll     $t2,                    $s4,                    2
    add     $t3,                    $s0,                    $t2
    lw      $s5,                    0($t3)                                          # vetor[j]
    addi    $a2,                    $a2,                    3

    ble     $s5,                    $s3,                    insert                  # if (vetor[j] > chave)

    sw      $s5,                    4($t3)                                          # vetor[j+1] = vetor[j]
    addi    $s4,                    $s4,                    -1
    addi    $a2,                    $a2,                    4
    j       while_insertion

insert:
    sll     $t4,                    $s4,                    2
    add     $t5,                    $s0,                    $t4
    sw      $s3,                    4($t5)                                          # vetor[j+1] = chave

    addi    $s2,                    $s2,                    1                       # i++
    addi    $a2,                    $a2,                    6
    j       loop_externo_insertion

fim:
    jr      $ra                                                                     # jump to $ra

print_vetor:
    move    $t9,                    $a0

    #imprime o vetor com espacos
    move    $s1,                    $a0                                             # base do vetor
    move    $t4,                    $a1                                             # tamanho do vetor
loopPrint:
    beq     $0,                     $t4,                    saida_print
    lw      $a0,                    ($s1)
    li      $v0,                    1
    syscall
    addi    $t4,                    $t4,                    -1
    addi    $s1,                    $s1,                    4
    li      $v0,                    4
    la      $a0,                    espaco                                          # espaco entre os numeros
    syscall
    j       loopPrint

saida_print:
    la      $a0,                    novalinha                                       # \n no final
    li      $v0,                    4
    syscall

    move    $a0,                    $t9
    jr      $ra

vetor_padrao:
    li      $t9,                    0x10010000                                      #endereco do vetor padrao
    li      $t8,                    34                                              #tamanho do vetor padrao
    la      $t6,                    vetor                                           #endereco do vetor ordenado

loop_vetor_padrao:
    beq     $t8,                    $0,                     fim_vetor_padrao

    lw      $t7,                    0($t9)
    sw      $t7,                    0($t6)

    addi    $t9,                    $t9,                    4
    addi    $t6,                    $t6,                    4

    addi    $t8,                    $t8,                    -1
    j       loop_vetor_padrao

fim_vetor_padrao:
    li      $a1,                    34
    jr      $ra
