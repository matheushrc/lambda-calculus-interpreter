# TRABALHO FINAL

O trabalho final da disciplina de Linguagens de Programação, turma 2025-2, do curso de Ciência da
Computação da UFFS - Campus Chapecó, consiste na escolha de uma funcionalidade para ser
implementada no Interpretador do Lambda Cálculo desenvolvido em sala, ou em alguma variação. Este
trabalho deve ser desenvolvido em duplas ou trios.

Funcionalidades possíveis: tipos de dados algébricos, uso de variáveis mutáveis (estado), exceções,
listas, tuplas, registros, etc.

Variações: implementar um compilador do lambda cálculo para a linguagem C ou para alguma outra
representação intermediária; Implementar uma linguagem diferente como IMP, Featherweight Java, etc.
A avaliação deste trabalho será dividida em duas etapas.

## DESENVOLVIMENTO DO INTERPRETADOR / COMPILADOR (7,0 pontos)

- Conclusão da implementação dos construtores sintáticos definidos em aula no lexer, parser,
  typechecker e interpreter.
- Adaptação correta do lexer e parser utilizando a ferramenta Happy. (2,0 pontos)
- Correta adaptação da Árvore de Sintaxe Abstrata (AST) com as novas funcionalidades. (1,0 ponto)
- Correta adaptação dos módulos Interpreter e TypeChecker. (3,0 pontos)
- Definição de exemplos de programas que podem ser executados na linguagem. (1,0 ponto)

## APRESENTAÇÃO ORAL E DEMONSTRAÇÃO DO CÓDIGO (3,0 pontos)

- Apresentação explicando a funcionalidade, a implementação e a justificativa de ter escolhido essa funcionalidade para a linguagem. (1,0 ponto)
- Explicação coerente dos passos desenvolvidos no trabalho, incluindo a análise léxica, sintática e semântica. (2,0 pontos)
- O envio dos códigos deve ocorrer até a data de 05/12/2025, às 18:00.

## RECUPERAÇÃO

- O estudante que não entregar/apresentar os códigos desenvolvidos até a data solicitada, poderá realizar a sua entrega/apresentação até o dia 12/12/2025, como recuperação, tendo uma penalidade de 2,0 pontos na nota final do trabalho.

## PLÁGIO

- Qualquer ocorrência de plágio (cópia da internet ou entre colegas) será tratada com rigor, sendo atribuída nota zero para todos os integrantes dos grupos envolvidos.

## Testando a gramatica

Compilar o código:

```pwsh
ghc -o interpreter Main.hs
```

Executar os testes:

```pwsh
Get-Content text_pwsh.txt | ForEach-Object { echo $_ | .\interpreter.exe }
```
