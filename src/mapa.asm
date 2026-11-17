# Matriz 6x6: cada ponto ('.') representa uma celula livre e '#' representa parede ou obstaculo.
# '*' representa sujeira e 'B' representa a base de recarga.
# Os obstaculos sao apenas exibidos; ainda nao ha regras de colisao.
# As linhas ficam juntas na memoria, sem terminadores entre elas.

.data
.globl mapa, mapa_linhas, mapa_colunas
.globl robo_linha, robo_coluna

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
