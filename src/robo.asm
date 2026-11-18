# CleanMIPS - Simulador de um Robo Aspirador

# As mensagens usam caracteres ASCII para facilitar a exibicao no console.
.data
boas_vindas: .asciiz "Bem-vindo ao CleanMIPS!\n"
menu:        .asciiz "\nW - Mover para cima\nS - Mover para baixo\nA - Mover para esquerda\nD - Mover para direita\nE - Consultar estado\nQ - Sair\nEscolha uma opcao: "
msg_bloqueado: .asciiz "Movimento bloqueado (parede ou borda).\n"
msg_status:    .asciiz "Bateria: "
msg_limpas:    .asciiz " | Limpas: "
msg_estado:  .asciiz "Consulta de estado sera implementada posteriormente.\n"
msg_invalida: .asciiz "Entrada invalida. Digite W, A, S, D, E ou Q.\n"
msg_saida:   .asciiz "Encerrando o CleanMIPS. Ate logo!\n"
entrada:     .space 64

.text
.globl main
main:
    li $v0, 4                   # Syscall 4: imprimir string em $a0.
    la $a0, boas_vindas
    syscall

    jal mostrar_mapa

loop_menu: # Menu Interativo para o console do MARS.
    li $v0, 4
    la $a0, menu
    syscall

    # main termina por syscall 10; nao precisamos retornar ao seu chamador.
    jal ler_comando
    beq $v0, 'Q', sair
    beq $v0, 'q', sair
    beq $v0, 'W', comando_cima
    beq $v0, 'w', comando_cima
    beq $v0, 'S', comando_baixo
    beq $v0, 's', comando_baixo
    beq $v0, 'A', comando_esquerda
    beq $v0, 'a', comando_esquerda
    beq $v0, 'D', comando_direita
    beq $v0, 'd', comando_direita
    beq $v0, 'E', comando_estado
    beq $v0, 'e', comando_estado

    la $a0, msg_invalida
    j exibir_resposta

comando_cima:
    li    $a0, 0
    j     chama_mover

comando_baixo:
    li    $a0, 2
    j     chama_mover

comando_esquerda:
    li    $a0, 1
    j     chama_mover

comando_direita:
    li    $a0, 3
    j     chama_mover

chama_mover:
    jal   tentar_mover
    beq   $v0, $zero, move_bloqueado
    j     status_mov

move_bloqueado:
    la    $a0, msg_bloqueado
    li    $v0, 4
    syscall
    j     loop_menu

status_mov:
    la    $a0, msg_status
    li    $v0, 4
    syscall

    lw    $a0, bateria
    li    $v0, 1
    syscall

    la    $a0, msg_limpas
    li    $v0, 4
    syscall

    lw    $a0, limpas
    li    $v0, 1
    syscall

    li    $a0, 10
    li    $v0, 11
    syscall

    jal   mostrar_mapa          # re-renderiza com a celula limpa e o R novo
    j     loop_menu 

comando_estado:
    la $a0, msg_estado

exibir_resposta:
    li $v0, 4
    syscall
    j loop_menu

sair:
    li $v0, 4
    la $a0, msg_saida
    syscall
    li $v0, 10                  # Syscall 10: encerrar o programa.
    syscall

# Exibe a matriz sem modificar suas celulas.
# Nao recebe parametros nem retorna valores; usa apenas registradores temporarios.
# Como nao chama outros procedimentos, nao precisa salvar $ra.
mostrar_mapa:
    la $t0, mapa
    lw $t1, mapa_linhas
    lw $t2, mapa_colunas
    lw $t6, robo_linha
    lw $t7, robo_coluna
    li $t3, 0                   # Linha atual, com indices a partir de zero.

loop_linhas:
    bge $t3, $t1, fim_mapa
    li $t4, 0                   # Reinicia a coluna a cada linha.

loop_colunas:
    bge $t4, $t2, fim_linha
    mul $t5, $t3, $t2           # Deslocamento = linha * colunas + coluna.
    addu $t5, $t5, $t4
    addu $t5, $t0, $t5          # Endereco da celula = base + deslocamento.
    lbu $a0, 0($t5)
    bne $t3, $t6, imprimir_celula
    bne $t4, $t7, imprimir_celula
    li $a0, 'R'                 # Mostra o robo sem sobrescrever a celula na memoria.

imprimir_celula:
    li $v0, 11                  # Syscall 11: imprimir um caractere.
    syscall
    addiu $t4, $t4, 1
    j loop_colunas

fim_linha:
    li $a0, 10                  # Quebra de linha depois das seis colunas.
    li $v0, 11
    syscall
    addiu $t3, $t3, 1
    j loop_linhas

fim_mapa:
    jr $ra

# Le uma linha como texto, evitando excecoes de conversao numerica.
# Retorna em $v0 um unico caractere, ou -1 se o formato for invalido.
# O loop do menu verifica se o caractere corresponde a um comando.
# Aceita exatamente um caractere, sem espacos adicionais.
ler_comando:
    li $v0, 8                   # Syscall 8: ler string com limite de tamanho.
    la $a0, entrada
    li $a1, 64                  # Inclui espaco para o terminador nulo.
    syscall

    la $t0, entrada
    lbu $t1, 0($t0)
    beq $t1, 10, entrada_invalida # Linha vazia.
    beqz $t1, entrada_invalida
    lbu $t0, 1($t0)
    beq $t0, 10, entrada_valida  # LF: fim da linha digitada.
    beqz $t0, entrada_valida     # NUL: fim da string.

entrada_invalida:
    li $v0, -1
    jr $ra

entrada_valida:
    move $v0, $t1
    jr $ra

# tenta_mover: $a0 = direcao (0=cima, 1=esquerda, 2=baixo, 3=direita)
# Retorna $v0 = 1 se moveu, 0 se bloqueado (parede ou borda).
# Movimento valido: atualiza robo_linha/robo_coluna, gasta 1 bateria e
# limpa a celula ocupada (se havia sujeira). Bloqueado: nao altera nada
tentar_mover:
    addiu $sp, $sp, -12
    sw    $ra, 8($sp)
    sw    $s0, 4($sp)
    sw    $s1, 0($sp)

    lw    $s0, robo_linha        # $s0 = linha atual
    lw    $s1, robo_coluna       # $s1 = coluna atual
    lw    $t1, mapa_linhas       # $t1 = N linhas
    lw    $t2, mapa_colunas      # $t2 = N colunas

    li    $v0, 0                 # padrao: bloqueado
    beq   $a0, $zero, dir_cima
    li    $t3, 1
    beq   $a0, $t3, dir_esq
    li    $t3, 2
    beq   $a0, $t3, dir_baixo
    li    $t3, 3
    beq   $a0, $t3, dir_dir
    j     fim_mover              # direcao invalida

dir_cima:
    slti  $t4, $s0, 1           # 1 se na borda de cima (linha == 0)
    beq   $t4, $zero, sobe
    j     fim_mover
sobe:
    addiu $s0, $s0, -1
    j     valida_destino

dir_esq:
    slti  $t4, $s1, 1           # 1 se na borda esquerda (coluna == 0)
    beq   $t4, $zero, anda
    j     fim_mover
anda:
    addiu $s1, $s1, -1
    j     valida_destino

dir_baixo:
    addiu $t4, $t1, -1          # $t4 = N-1
    slt   $t5, $s0, $t4         # 1 se linha < N-1 (pode descer)
    beq   $t5, $zero, fim_mover
    addiu $s0, $s0, 1
    j     valida_destino

dir_dir:
    addiu $t4, $t2, -1          # $t4 = N-1
    slt   $t5, $s1, $t4         # 1 se coluna < N-1 (pode ir a direita)
    beq   $t5, $zero, fim_mover
    addiu $s1, $s1, 1
    j     valida_destino

valida_destino:
    mult  $s0, $t2              # $lo = linha * colunas
    mflo  $t4                   # $t4 = deslocamento da linha
    addu  $t4, $t4, $s1         # $t4 = indice da celula
    la    $t5, mapa
    addu  $t5, $t5, $t4         # $t5 = endereco da celula
    lbu   $t6, 0($t5)           # $t6 = caractere do destino
    li    $t7, '#'
    beq   $t6, $t7, fim_mover   # parede: bloqueado

    # ---- movimento valido ----
    li    $v0, 1
    sw    $s0, robo_linha
    sw    $s1, robo_coluna

    # gasta 1 bateria
    lw    $t7, bateria
    addiu $t7, $t7, -1
    sw    $t7, bateria

    # limpa a celula se havia sujeira
    li    $t7, '*'
    bne   $t6, $t7, fim_mover
    li    $t7, '.'
    sb    $t7, 0($t5)           # marca a celula como limpa
    lw    $t7, sujeirasRestantes
    addiu $t7, $t7, -1
    sw    $t7, sujeirasRestantes
    lw    $t7, limpas
    addiu $t7, $t7, 1
    sw    $t7, limpas
    j     fim_mover

fim_mover:
    lw    $s1, 0($sp)
    lw    $s0, 4($sp)
    lw    $ra, 8($sp)
    addiu $sp, $sp, 12
    jr    $ra