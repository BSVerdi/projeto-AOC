# Matriz 6x6: cada ponto ('.') representa uma celula livre e '#' representa parede ou obstaculo.
# '*' representa sujeira e 'B' representa a base de recarga.
# Os obstaculos sao apenas exibidos; ainda nao ha regras de colisao.
# As linhas ficam juntas na memoria, sem terminadores entre elas.

.data
.globl mapa, mapa_linhas, mapa_colunas
.globl robo_linha, robo_coluna
.globl bateria, sujeirasRestantes, limpas

# Recurso e estado da limpeza (usados por tentar_mover em robo.asm).
# Bateria 30: o caminho minimo para limpar as 8 sujeiras e 23 movimentos,
# entao 30 garante que a missao e possivel sem ser trivial.
bateria:           .word 30
sujeirasRestantes: .word 8
limpas:            .word 0

mapa_linhas:  .word 6
mapa_colunas: .word 6
# O robo comeca sobre a base. Sua posicao fica separada das celulas do mapa.
robo_linha:   .word 0
robo_coluna:  .word 0
mapa:
    .ascii "B.*.#."
    .ascii ".#.*.."
    .ascii "*..#.*"
    .ascii ".*...."
    .ascii ".#*.#."
    .ascii "*...*."
