# CleanMIPS - Simulador de um Robo Aspirador

# As mensagens usam caracteres ASCII para facilitar a exibicao no console.
.data
boas_vindas: .asciiz "Bem-vindo ao CleanMIPS!\n"
menu:        .asciiz "\nW - Mover para cima\nS - Mover para baixo\nA - Mover para esquerda\nD - Mover para direita\nE - Consultar estado\nQ - Sair\nEscolha uma opcao: "
msg_cima:    .asciiz "Comando para cima reconhecido. Movimentacao ainda nao implementada.\n"
msg_baixo:   .asciiz "Comando para baixo reconhecido. Movimentacao ainda nao implementada.\n"
msg_esquerda: .asciiz "Comando para esquerda reconhecido. Movimentacao ainda nao implementada.\n"
msg_direita: .asciiz "Comando para direita reconhecido. Movimentacao ainda nao implementada.\n"
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
    la $a0, msg_cima
    j exibir_resposta
comando_baixo:
    la $a0, msg_baixo
    j exibir_resposta
comando_esquerda:
    la $a0, msg_esquerda
    j exibir_resposta
comando_direita:
    la $a0, msg_direita
    j exibir_resposta
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
