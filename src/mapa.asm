# Matriz 6x6: cada ponto representa uma celula livre.
# As linhas ficam juntas na memoria, sem terminadores entre elas.

.data
.globl mapa, mapa_linhas, mapa_colunas

mapa_linhas:  .word 6
mapa_colunas: .word 6
mapa:
    .ascii "......"
    .ascii "......"
    .ascii "......"
    .ascii "......"
    .ascii "......"
    .ascii "......"
