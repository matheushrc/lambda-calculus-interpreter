#!/bin/bash

echo "=========================================="
echo "✓ TESTES FINAIS - VARIÁVEIS E APP"
echo "=========================================="
echo ""

PASS=0
FAIL=0

run_test() {
    local name="$1"
    local input="$2"
    local expected="$3"
    
    echo "[$((PASS+FAIL+1))] $name"
    result=$(printf "%s" "$input" | ./lambda 2>&1)
    
    if echo "$result" | grep -q "$expected"; then
        echo "    ✓ $result"
        ((PASS++))
    else
        echo "    ✗ Got: $result"
        echo "    ✗ Expected: $expected"
        ((FAIL++))
    fi
}

echo "===== TESTES DE VARIÁVEIS ====="
run_test "Variável simples" \
    "(lambda x : Num . x) 42" \
    "Num 42"

run_test "Variável usada múltiplas vezes" \
    "(lambda x : Num . x + x + x) 5" \
    "Num 15"

run_test "Variável com tipo Bool" \
    "(lambda b : Bool . b) true" \
    "BTrue"

run_test "Shadowing de variável" \
    "(lambda x : Num . (lambda x : Num . x) 10) 20" \
    "Num 10"

run_test "Shadowing complexo" \
    "(lambda x : Num . x + ((lambda x : Num . x * 2) 5)) 3" \
    "Num 13"

run_test "Múltiplas variáveis" \
    "((lambda x : Num . lambda y : Num . x + y) 10) 20" \
    "Num 30"

run_test "Variável em expressão complexa" \
    "(lambda x : Num . (x + 1) * (x + 2)) 3" \
    "Num 20"

echo ""
echo "===== TESTES DE APLICAÇÃO (APP) ====="
run_test "Aplicação simples" \
    "(lambda x : Num . x * 2) 5" \
    "Num 10"

run_test "Aplicação com argumento complexo" \
    "(lambda x : Num . x + 1) (3 * 4)" \
    "Num 13"

run_test "Aplicação aninhada" \
    "((lambda x : Num . lambda y : Num . x * y) 6) 7" \
    "Num 42"

run_test "Aplicação em cadeia (3 args)" \
    "(((lambda a : Num . lambda b : Num . lambda c : Num . a + b + c) 1) 2) 3" \
    "Num 6"

run_test "Aplicação em cadeia (4 args)" \
    "((((lambda a : Num . lambda b : Num . lambda c : Num . lambda d : Num . a + b + c + d) 1) 2) 3) 4" \
    "Num 10"

echo ""
echo "===== HIGHER-ORDER FUNCTIONS ====="
run_test "Função que recebe função" \
    "(lambda f : Num -> Num . (f 5)) (lambda x : Num . x + 1)" \
    "Num 6"

run_test "Função que retorna função aplicada" \
    "((lambda f : Num -> Num . lambda x : Num . (f x)) (lambda y : Num . y * 2)) 10" \
    "Num 20"

run_test "Apply twice - aplicar 2x" \
    "((lambda f : Num -> Num . lambda x : Num . (f (f x))) (lambda n : Num . n + 1)) 0" \
    "Num 2"

run_test "Apply twice - outro exemplo" \
    "((lambda f : Num -> Num . lambda x : Num . (f (f x))) (lambda n : Num . n * 2)) 3" \
    "Num 12"

run_test "Função aninhada complexa" \
    "((lambda g : Num -> Num . lambda x : Num . (g x)) (lambda z : Num . z + 3)) 7" \
    "Num 10"

echo ""
echo "===== COMBINAÇÕES COM IF ====="
run_test "Lambda com if no corpo" \
    "(lambda x : Num . if true x 0) 42" \
    "Num 42"

run_test "Lambda com if e bool var" \
    "((lambda b : Bool . lambda x : Num . if b x 0) true) 100" \
    "Num 100"

run_test "Lambda com if e bool var false" \
    "((lambda b : Bool . lambda x : Num . if b x 0) false) 100" \
    "Num 0"

run_test "If com lambdas nos ramos" \
    "(lambda x : Num . if true ((lambda y : Num . y + 1) x) x) 5" \
    "Num 6"

echo ""
echo "===== OPERADORES BOOLEANOS ====="
run_test "Lambda com AND" \
    "((lambda a : Bool . lambda b : Bool . a && b) true) false" \
    "BFalse"

run_test "Lambda com OR" \
    "((lambda a : Bool . lambda b : Bool . a || b) false) true" \
    "BTrue"

run_test "Lambda com operações complexas" \
    "((lambda a : Bool . lambda b : Bool . (a || b) && a) true) false" \
    "BTrue"

echo ""
echo "===== TESTES COM TUPLAS ====="
run_test "Lambda com tupla" \
    "(lambda x : Num . {x, x + 1, x * 2}) 5" \
    "Tuple"

run_test "Lambda com projeção" \
    "(lambda x : Num . {x, x + 1}.1) 10" \
    "Num 10"

run_test "Lambda com projeção índice 2" \
    "(lambda x : Num . {x, x + 1}.2) 10" \
    "Num 11"

echo ""
echo "===== TESTES DE TIPO (ERROS ESPERADOS) ====="
run_test "Type error - Bool para Num" \
    "(lambda x : Num . x + 1) true" \
    "Type error"

run_test "Type error - Num para Bool" \
    "(lambda x : Bool . x && true) 5" \
    "Type error"

run_test "Type error - função errada" \
    "(lambda f : Bool -> Bool . (f 5)) (lambda x : Num . x)" \
    "Type error"

echo ""
echo "=========================================="
echo "RESULTADO FINAL: $PASS ✓  $FAIL ✗"
if [ $FAIL -eq 0 ]; then
    echo "🎉 TODOS OS TESTES PASSARAM! 🎉"
else
    echo "⚠️  Alguns testes falharam"
fi
echo "=========================================="
