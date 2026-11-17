# CleanMIPS — Robô Aspirador — CRIATHON MIPS

Simulação de um **robô aspirador** em **Assembly MIPS**, executada no simulador **MARS**.
O robô percorre uma grade, limpa as células com sujeira, gasta bateria a cada movimento e tenta limpar todo o mapa antes de ficar sem energia.

> Projeto da disciplina **Arquitetura e Organização de Computadores** — CRIATHON MIPS
> (Prof.ª Denise Stringhini • ICT/Unifesp).

## Sobre o produto

O CleanMIPS é um simulador interativo de um robô aspirador em MIPS. Uma **matriz** representará o ambiente com três tipos de célula:

- `#` — **parede** (impassável)
- `.` — **célula livre** (já limpa)
- `*` — **célula com sujeira**

O usuário comandará o robô por **controle manual**. A cada movimento o robô **gastará energia** e **limpará a célula que ocupar**. O programa manterá o **mapa**, a **bateria** e o **contador de células limpas**, e encerrará quando não houver mais sujeira (vitória) ou quando a bateria se esgotar (derrota).

## Como funciona

**Implementado — Incremento 01:** boas-vindas, menu com comandos WASD, leitura e validação de comandos, mensagens provisórias, repetição do menu e encerramento pela opção `Q`.

**Planejado para os próximos incrementos:**

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

Digite uma opção e pressione **Enter**. Todos os comandos aceitam letras maiúsculas ou minúsculas:

| Opção | Comando | Comportamento atual |
| :---: | :------ | :------------------ |
| `W` | Mover para **cima** | Reconhece o comando; movimento ainda não implementado |
| `S` | Mover para **baixo** | Reconhece o comando; movimento ainda não implementado |
| `A` | Mover para **esquerda** | Reconhece o comando; movimento ainda não implementado |
| `D` | Mover para **direita** | Reconhece o comando; movimento ainda não implementado |
| `E` | Consultar estado | Informa que a consulta será implementada posteriormente |
| `Q` | Sair | Encerra a execução |

**Entradas inválidas:** a leitura é feita como string. Comandos fora de WASD, `E` e `Q`, linhas vazias e comandos com mais de um caractere (inclusive espaços) são rejeitados com mensagem de erro. O menu reaparece após cada comando, exceto ao selecionar `Q`.

## Como executar

### Pré-requisitos

- **MARS** (MIPS Assembler and Runtime Simulator) 4.5, com Java instalado.

### Passos

1. Clone o repositório:

   ```bash
   git clone https://github.com/BSVerdi/projeto-AOC.git
   ```

2. Abra o MARS e carregue `src/robo.asm` em **File > Open**.
3. Monte o programa em **Run > Assemble** e execute em **Run > Go**.
4. Digite os comandos no console **Run I/O**, pressionando Enter após cada opção.

### Configuração do MARS

Mantenha as pseudoinstruções habilitadas e a opção **Delayed branching** desabilitada (configuração padrão). O arquivo `src/robo.asm` funciona sozinho; não é necessário carregar `src/mapa.asm`.

## Estrutura do repositório

```
├── README.md
├── src/
│ ├── robo.asm # arquivo principal: menu interativo
│ └── mapa.asm # reservado para dados do ambiente; ainda vazio
└── docs/
  ├── ficha-tecnica.md
  ├── testes.md
  └── uso-ia.md

```

## Limitações

O menu apenas reconhece comandos e apresenta mensagens. Matriz, coordenadas, obstáculos,limpeza, bateria, recarga, vitória/derrota, movimentação automática e interface gráfica ficam para os próximos incrementos.

## Validação do menu

Execute cada sequência no console, pressionando Enter após cada entrada:

| Cenário | Entradas | Resultado esperado |
| :------ | :------- | :----------------- |
| Movimento para cima | `W`, `Q` | Reconhece cima, informa que não há movimento implementado e encerra |
| Consulta de estado | `E`, `Q` | Exibe a mensagem provisória e encerra |
| Entradas inválidas | `9`, `x`, `Q` | Exibe dois erros, permite nova tentativa e encerra |
| Repetição | `W`, `S`, `A`, `D`, `E`, `Q` | Responde a todos os comandos e reapresenta o menu até sair |
| Encerramento | `Q` | Exibe despedida e termina sem reapresentar o menu |

**Resultado observado:** os cinco cenários passaram no MARS 4.5 via linha de comando, com pseudoinstruções habilitadas e delayed branching desabilitado.
Também foram reconhecidas as quatro direções, a consulta e a saída com letras maiúsculas e minúsculas. 
Foram rejeitados os comandos com linhas vazias, `10`, `0a`, `W `, ` W`, `-1` e uma linha com 200 caracteres. Todas as execuções terminaram com a mensagem de despedida e código de saída zero.

A interface gráfica do MARS não foi testada.

Para repetir pelo terminal, com o JAR do MARS disponível:

```bash
java -jar /caminho/Mars4_5.jar nc me ae1 se2 src/robo.asm
```

## Vídeo final

Demonstração final do Robô Aspirador

## Integrantes

Luiz Moloni & Breno Silveira
