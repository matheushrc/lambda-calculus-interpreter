# 📚 Exemplos de Uso - Lambda Calculus Interpreter

## ✅ Status: 30/30 testes passando (100%)

## 🚀 Quick Start

### Compilar
```bash
ghc -o lambda Main.hs
```

### Executar um exemplo
```bash
echo "(lambda x : Num . x + 2) 3" | ./lambda
# Output: Num 5
```

## 📝 Exemplos Práticos

### 1. Variáveis

#### Variável simples
```haskell
(lambda x : Num . x) 42
-- Output: Num 42
```

#### Variável usada múltiplas vezes
```haskell
(lambda x : Num . x + x + x) 5
-- Output: Num 15
```

#### Variável em expressão complexa
```haskell
(lambda x : Num . (x + 1) * (x + 2)) 3
-- Output: Num 20
-- Explicação: (3 + 1) * (3 + 2) = 4 * 5 = 20
```

### 2. Aplicação de Função (APP)

#### Aplicação simples
```haskell
(lambda x : Num . x * 2) 5
-- Output: Num 10
```

#### Aplicação com argumento complexo
```haskell
(lambda x : Num . x + 1) (3 * 4)
-- Output: Num 13
-- Explicação: primeiro calcula 3 * 4 = 12, depois 12 + 1 = 13
```

#### Currying (múltiplos parâmetros)
```haskell
((lambda x : Num . lambda y : Num . x + y) 10) 20
-- Output: Num 30
```

#### Currying com 3 parâmetros
```haskell
(((lambda a : Num . lambda b : Num . lambda c : Num . a + b + c) 1) 2) 3
-- Output: Num 6
```

### 3. Variable Shadowing

#### Shadowing simples
```haskell
(lambda x : Num . (lambda x : Num . x) 10) 20
-- Output: Num 10
-- Explicação: x interno (10) sobrescreve x externo (20)
```

#### Shadowing complexo
```haskell
(lambda x : Num . x + ((lambda x : Num . x * 2) 5)) 3
-- Output: Num 13
-- Explicação: x externo = 3, x interno = 5
-- Cálculo: 3 + (5 * 2) = 3 + 10 = 13
```

### 4. Higher-Order Functions

#### Função que recebe função
```haskell
(lambda f : Num -> Num . (f 10)) (lambda x : Num . x * 2)
-- Output: Num 20
-- Explicação: aplica (x * 2) com x = 10
```

#### Apply Twice (aplica função 2 vezes)
```haskell
((lambda f : Num -> Num . lambda x : Num . (f (f x))) (lambda n : Num . n + 1)) 0
-- Output: Num 2
-- Explicação: aplica (n + 1) duas vezes
-- Passo 1: f(0) = 0 + 1 = 1
-- Passo 2: f(1) = 1 + 1 = 2
```

#### Apply Twice com multiplicação
```haskell
((lambda f : Num -> Num . lambda x : Num . (f (f x))) (lambda n : Num . n * 2)) 3
-- Output: Num 12
-- Explicação: 
-- Passo 1: f(3) = 3 * 2 = 6
-- Passo 2: f(6) = 6 * 2 = 12
```

### 5. Combinações com IF

#### Lambda com IF
```haskell
(lambda x : Num . if true x 0) 42
-- Output: Num 42
```

#### IF com variável booleana
```haskell
((lambda b : Bool . lambda x : Num . if b (x * 2) x) true) 21
-- Output: Num 42
-- Explicação: b = true, então retorna x * 2 = 21 * 2 = 42
```

#### IF com false
```haskell
((lambda b : Bool . lambda x : Num . if b (x * 2) x) false) 21
-- Output: Num 21
-- Explicação: b = false, então retorna x = 21
```

### 6. Operadores Booleanos

#### AND
```haskell
((lambda a : Bool . lambda b : Bool . a && b) true) false
-- Output: BFalse
```

#### OR
```haskell
((lambda a : Bool . lambda b : Bool . a || b) false) true
-- Output: BTrue
```

#### Operação complexa
```haskell
((lambda a : Bool . lambda b : Bool . (a || b) && a) true) false
-- Output: BTrue
-- Explicação: (true || false) && true = true && true = true
```

### 7. Integração com Tuplas

#### Lambda retornando tupla
```haskell
(lambda x : Num . {x, x + 1, x * 2}) 5
-- Output: Tuple [Num 5, Num 6, Num 10]
```

#### Projeção de tupla (índice 1)
```haskell
(lambda x : Num . {x, x + 1}.1) 10
-- Output: Num 10
```

#### Projeção de tupla (índice 2)
```haskell
(lambda x : Num . {x, x + 1}.2) 10
-- Output: Num 11
```

## ⚠️ Regras de Sintaxe Importantes

### Parênteses são obrigatórios!

#### ❌ ERRADO (lambda captura tudo)
```haskell
lambda x : Num . x + 1 5
-- Parseado como: lambda x : Num . (x + 1 5) -- ERRO!
```

#### ✓ CORRETO
```haskell
(lambda x : Num . x + 1) 5
-- Output: Num 6
```

### Currying precisa de parênteses

#### ❌ ERRADO
```haskell
lambda x : Num . lambda y : Num . x + y 3 4
```

#### ✓ CORRETO
```haskell
((lambda x : Num . lambda y : Num . x + y) 3) 4
-- Output: Num 7
```

### Higher-order functions precisam de parênteses extras

#### ✓ CORRETO
```haskell
(lambda f : Num -> Num . (f 5)) (lambda x : Num . x + 1)
-- Output: Num 6
-- Note os parênteses ao redor de (f 5)!
```

## 🧪 Type Checking (Erros Detectados)

### Erro: Bool para Num
```haskell
(lambda x : Num . x + 1) true
-- Output: Type error!
```

### Erro: Num para Bool
```haskell
(lambda x : Bool . x && true) 5
-- Output: Type error!
```

### Erro: Tipo de função errado
```haskell
(lambda f : Bool -> Bool . (f 5)) (lambda x : Num . x)
-- Output: Type error!
```

## 🔧 Funções Implementadas

### Todas as funções solicitadas foram implementadas:

1. **`step`** (Interpreter.hs)
   - ✅ Beta reduction para aplicação
   - ✅ Call-by-value evaluation
   - ✅ Unwrap de Paren
   - ✅ Tratamento de erros

2. **`subst`** (Interpreter.hs)
   - ✅ Substituição de variáveis
   - ✅ Variable shadowing correto
   - ✅ Substituição recursiva

3. **`lexer`** (Lexer.hs)
   - ✅ Tokenização de variáveis
   - ✅ Token `lambda`
   - ✅ Tokens de tipos (`:`, `->`, `Num`, `Bool`)

4. **`typeof`** (TypeChecker.hs)
   - ✅ Type checking de variáveis
   - ✅ Type checking de lambdas
   - ✅ Type checking de aplicação

5. **`isValue`** (Interpreter.hs)
   - ✅ Lambdas são valores
   - ✅ Números e booleanos são valores
   - ✅ Tuplas de valores são valores

## 📊 Resumo de Testes

- **Total de testes:** 30
- **Testes passando:** 30 ✅
- **Taxa de sucesso:** 100%

## 🎯 Conclusão

✅ Implementação completa e funcional de:
- Variáveis
- Lambdas (abstrações)
- Aplicação de função (APP)
- Variable shadowing
- Higher-order functions
- Type checking robusto
