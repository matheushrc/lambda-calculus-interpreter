#!/bin/bash

echo "════════════════════════════════════════════════════════════════"
echo "TESTES PRÁTICOS - CRIANDO FUNÇÕES COM LAMBDAS E APP"
echo "════════════════════════════════════════════════════════════════"
echo ""

PASS=0
FAIL=0

test_func() {
    local desc="$1"
    local func_name="$2"
    local input="$3"
    local expected="$4"
    
    echo "┌─────────────────────────────────────────────────────────────"
    echo "│ $desc"
    echo "│ Função: $func_name"
    echo "│ Input: $input"
    result=$(printf "%s" "$input" | ./lambda 2>&1)
    
    if echo "$result" | grep -q "$expected"; then
        echo "│ ✓ Resultado: $result"
        ((PASS++))
    else
        echo "│ ✗ Resultado: $result"
        echo "│ ✗ Esperado: $expected"
        ((FAIL++))
    fi
    echo "└─────────────────────────────────────────────────────────────"
    echo ""
}

echo "═══════════════════════════════════════════════════════════════"
echo "1. FUNÇÕES MATEMÁTICAS BÁSICAS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Função incremento" \
    "inc = λn. n + 1" \
    "(lambda n : Num . n + 1) 5" \
    "Num 6"

test_func "Função decremento" \
    "dec = λn. n + (0 * 1)" \
    "(lambda n : Num . n + (0 * 1)) 10" \
    "Num 10"

test_func "Função dobro" \
    "double = λx. x * 2" \
    "(lambda x : Num . x * 2) 7" \
    "Num 14"

test_func "Função triplo" \
    "triple = λx. x * 3" \
    "(lambda x : Num . x * 3) 4" \
    "Num 12"

test_func "Função quadrado" \
    "square = λx. x * x" \
    "(lambda x : Num . x * x) 5" \
    "Num 25"

test_func "Função cubo" \
    "cube = λx. x * x * x" \
    "(lambda x : Num . x * x * x) 3" \
    "Num 27"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "2. FUNÇÕES COM DOIS ARGUMENTOS (CURRYING)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Função soma" \
    "add = λa. λb. a + b" \
    "((lambda a : Num . lambda b : Num . a + b) 5) 3" \
    "Num 8"

test_func "Função multiplicação" \
    "mult = λa. λb. a * b" \
    "((lambda a : Num . lambda b : Num . a * b) 6) 7" \
    "Num 42"

test_func "Função subtração simulada" \
    "sub = λa. λb. a + (b * 0)" \
    "((lambda a : Num . lambda b : Num . a + (b * 0)) 10) 3" \
    "Num 10"

test_func "Função média de dois números" \
    "avg2 = λa. λb. (a + b) * 0 + a" \
    "((lambda a : Num . lambda b : Num . (a + b) * 0 + a) 10) 20" \
    "Num 10"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "3. APLICAÇÃO PARCIAL (PARTIAL APPLICATION)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Criar função add5" \
    "add5 = add 5" \
    "((lambda a : Num . lambda b : Num . a + b) 5) 10" \
    "Num 15"

test_func "Criar função mult10" \
    "mult10 = mult 10" \
    "((lambda a : Num . lambda b : Num . a * b) 10) 3" \
    "Num 30"

test_func "Criar função addX onde X=7" \
    "add7 = (λa. λb. a + b) 7" \
    "((lambda a : Num . lambda b : Num . a + b) 7) 8" \
    "Num 15"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "4. FUNÇÕES DE ORDEM SUPERIOR"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Aplicar função 1x" \
    "apply = λf. λx. f x" \
    "((lambda f : Num -> Num . lambda x : Num . (f x)) (lambda n : Num . n + 1)) 5" \
    "Num 6"

test_func "Aplicar função 2x (twice)" \
    "twice = λf. λx. f (f x)" \
    "((lambda f : Num -> Num . lambda x : Num . (f (f x))) (lambda n : Num . n + 1)) 5" \
    "Num 7"

test_func "Aplicar função 3x (thrice)" \
    "thrice = λf. λx. f (f (f x))" \
    "((lambda f : Num -> Num . lambda x : Num . (f (f (f x)))) (lambda n : Num . n + 1)) 0" \
    "Num 3"

test_func "Aplicar função 2x com dobro" \
    "twice double 3" \
    "((lambda f : Num -> Num . lambda x : Num . (f (f x))) (lambda n : Num . n * 2)) 3" \
    "Num 12"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "5. COMPOSIÇÃO DE FUNÇÕES"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Compor: dobro depois incremento" \
    "compose double inc" \
    "((lambda f : Num -> Num . lambda g : Num -> Num . lambda x : Num . (f (g x))) (lambda a : Num . a * 2) (lambda b : Num . b + 1)) 5" \
    "Num 12"

test_func "Compor: incremento depois dobro" \
    "compose inc double" \
    "((lambda f : Num -> Num . lambda g : Num -> Num . lambda x : Num . (f (g x))) (lambda a : Num . a + 1) (lambda b : Num . b * 2)) 5" \
    "Num 11"

test_func "Pipeline: x |> double |> inc" \
    "pipe = λx. λf. f x" \
    "((lambda x : Num . lambda f : Num -> Num . (f x)) 5) (lambda n : Num . n * 2)" \
    "Num 10"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "6. FUNÇÕES BOOLEANAS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Função NOT" \
    "not = λb. if b false true" \
    "(lambda b : Bool . if b false true) true" \
    "BFalse"

test_func "Função AND" \
    "and = λa. λb. a && b" \
    "((lambda a : Bool . lambda b : Bool . a && b) true) false" \
    "BFalse"

test_func "Função OR" \
    "or = λa. λb. a || b" \
    "((lambda a : Bool . lambda b : Bool . a || b) false) true" \
    "BTrue"

test_func "Função identidade booleana" \
    "id = λx. x" \
    "(lambda x : Bool . x) true" \
    "BTrue"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "7. FUNÇÕES CONDICIONAIS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Função isPositive (simulado)" \
    "isPositive = λn. if true n 0" \
    "(lambda n : Num . if true n 0) 42" \
    "Num 42"

test_func "Função abs (valor absoluto simulado)" \
    "abs = λn. if true n (n * 0)" \
    "(lambda n : Num . if true n (n * 0)) 5" \
    "Num 5"

test_func "Função max simulado" \
    "max = λa. λb. if true a b" \
    "((lambda a : Num . lambda b : Num . if true a b) 10) 5" \
    "Num 10"

test_func "Função ifThenElse" \
    "ifThenElse = λc. λt. λe. if c t e" \
    "(((lambda c : Bool . lambda t : Num . lambda e : Num . if c t e) true) 100) 200" \
    "Num 100"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "8. FUNÇÕES COMPLEXAS (COMBINADORES)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Combinador K (const)" \
    "K = λx. λy. x" \
    "((lambda x : Num . lambda y : Num . x) 42) 99" \
    "Num 42"

test_func "Combinador K* (const retorna segundo)" \
    "K* = λx. λy. y" \
    "((lambda x : Num . lambda y : Num . y) 42) 99" \
    "Num 99"

test_func "Combinador S simplificado" \
    "S = λf. λg. λx. (f x) + (g x)" \
    "(((lambda f : Num -> Num . lambda g : Num -> Num . lambda x : Num . (f x) + (g x)) (lambda a : Num . a * 2)) (lambda b : Num . b + 1)) 5" \
    "Num 16"

test_func "Flip (inverter ordem de argumentos)" \
    "flip = λf. λa. λb. (f b) a" \
    "(((lambda f : Num -> Num -> Num . lambda a : Num . lambda b : Num . ((f b) a)) (lambda x : Num . lambda y : Num . x + y)) 3) 7" \
    "Num 10"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "9. CLOSURES (CAPTURA DE VARIÁVEIS)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Closure: captura variável externa" \
    "makeAdder = λn. (λx. n + x)" \
    "((lambda n : Num . lambda x : Num . n + x) 10) 5" \
    "Num 15"

test_func "Closure: multiplicador com variável capturada" \
    "makeMultiplier = λn. (λx. n * x)" \
    "((lambda n : Num . lambda x : Num . n * x) 5) 7" \
    "Num 35"

test_func "Closure: função dentro de função" \
    "outer = λx. (λy. (λz. x + y + z))" \
    "(((lambda x : Num . lambda y : Num . lambda z : Num . x + y + z) 1) 2) 3" \
    "Num 6"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "10. FUNÇÕES PARA MANIPULAÇÃO DE TUPLAS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

test_func "Criar par" \
    "makePair = λx. λy. {x, y}" \
    "((lambda x : Num . lambda y : Num . {x, y}) 10) 20" \
    "Tuple"

test_func "Pegar primeiro elemento" \
    "fst = λx. λy. {x, y}.1" \
    "((lambda x : Num . lambda y : Num . {x, y}.1) 42) 99" \
    "Num 42"

test_func "Pegar segundo elemento" \
    "snd = λx. λy. {x, y}.2" \
    "((lambda x : Num . lambda y : Num . {x, y}.2) 42) 99" \
    "Num 99"

test_func "Criar tripla" \
    "makeTriple = λa. λb. λc. {a, b, c}" \
    "(((lambda a : Num . lambda b : Num . lambda c : Num . {a, b, c}) 1) 2) 3" \
    "Tuple"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "RESULTADO FINAL: $PASS ✓  $FAIL ✗"
if [ $FAIL -eq 0 ]; then
    echo "🎉 TODAS AS FUNÇÕES FUNCIONAM PERFEITAMENTE! 🎉"
else
    echo "⚠️  Algumas funções falharam"
fi
echo "════════════════════════════════════════════════════════════════"
