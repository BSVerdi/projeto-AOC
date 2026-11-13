# Robô Aspirador — CRIATHON MIPS

Simulação de um **robô aspirador** em **Assembly MIPS**, executada no simulador **MARS**.
O robô percorre uma grade, limpa as células com sujeira, gasta bateria a cada movimento
e tenta limpar todo o mapa antes de ficar sem energia.

> Projeto da disciplina **Arquitetura e Organização de Computadores** — CRIATHON MIPS
> (Prof.ª Denise Stringhini • ICT/Unifesp).

## Sobre o produto

O Robô Aspirador é um programa interativo e criativo em MIPS. Uma **matriz** representa o
ambiente com três tipos de célula:

- `#` — **parede** (impassável)
- `.` — **célula livre** (já limpa)
- `*` — **célula com sujeira**

O usuário comanda o robô por **controle manual**. A cada movimento o robô **gasta energia**
e **limpa a célula que ocupa**. O programa mantém o **mapa**, a **bateria** e o **contador
de células limpas**, e encerra quando não há mais sujeira (vitória) ou quando a bateria
se esgota (derrota).

## Como funciona

1. O MARS exibe o mapa inicial com o robô em uma célula livre.
2. A cada tecla de movimento o programa:
   - **valida** o destino (parede ou fora do mapa bloqueiam o movimento e não gastam bateria);
   - **desconta** energia da bateria;
   - **move** o robô e **limpa** a célula ocupada;
   - **atualiza** o contador de células limpas e reexibe o mapa.
3. **Vitória:** todas as células `*` foram limpas.
4. **Derrota:** a bateria chega a zero e ainda há sujeira no mapa.
5. O usuário pode encerrar a qualquer momento.

## Comandos de interação

| Tecla | Ação                            |
| :---: | :------------------------------ |
|  `W`  | Move o robô para **cima**       |
|  `A`  | Move o robô para a **esquerda** |
|  `S`  | Move o robô para **baixo**      |
|  `D`  | Move o robô para a **direita**  |
|  `H`  | Mostra a tela de **ajuda**      |
|  `Q`  | **Encerra** a execução          |

**Entradas inválidas:** teclas fora do conjunto acima são rejeitadas com mensagem de erro
e não alteram o estado. Tentativas de entrar em parede ou sair do mapa são bloqueadas.
A execução encerra de forma clara via `Q`, vitória ou derrota.

## Como executar

### Pré-requisitos

- **MARS** (MIPS Assembler and Runtime Simulator) 5.x ou superior, com Java instalado.

### Passos

1. Clone o repositório:

   ```bash
   git clone https://github.com/BSVerdi/projeto-AOC.git
   ```

2. Abra o MARS:

### Configuração do MARS

### Estrutura do repositório

```
├── README.md
├── src/
│ ├── robo_aspirador.asm # arquivo principal
│ └── mapa.asm # dados iniciais (matriz, bateria, posição)
└── docs/
├── ficha-tecnica.md
├── testes.md
└── uso-ia.md

```

## Limitações

## Vídeo final

Demonstração final do Robô Aspirador

## Integrantes

|   Integrante   |
| :------------: |
|  Luiz Moloni   |
| Breno Silveira |
