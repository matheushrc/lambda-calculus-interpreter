import Interpreter
import Lexer (Expr, lexer)
import Parser
import TypeChecker

-- Função auxiliar para avaliar expressões a partir de strings
evalStr :: String -> Expr
evalStr = eval . typecheck . parser . lexer

-- =============================================================================
-- TESTES INDIVIDUAIS PARA CADA FUNCIONALIDADE (LINGUAGEM NATURAL)
-- =============================================================================

-- Test 1: Add - Adição de números
-- Expressão: "3 + 5"
testAdd :: IO ()
testAdd = do
  putStrLn "Test 1 - Add (3 + 5):"
  print $ evalStr "3 + 5"

-- Test 2: And - Conjunção lógica
-- Expressão: "true && false"
testAnd :: IO ()
testAnd = do
  putStrLn "\nTest 2 - And (true && false):"
  print $ evalStr "true && false"

-- Test 3: App - Aplicação de função
-- Expressão: "(\\x : Num -> x + 1) 5"
testApp :: IO ()
testApp = do
  putStrLn "\nTest 3 - App ((\\x : Num -> x + 1) 5):"
  print $ evalStr "(\\x : Num -> x + 1) 5"

-- Test 4: BFalse - Valor booleano falso
-- Expressão: "false"
testBFalse :: IO ()
testBFalse = do
  putStrLn "\nTest 4 - BFalse (false):"
  print $ evalStr "false"

-- Test 5: BTrue - Valor booleano verdadeiro
-- Expressão: "true"
testBTrue :: IO ()
testBTrue = do
  putStrLn "\nTest 5 - BTrue (true):"
  print $ evalStr "true"

-- Test 6: If - Condicional
-- Expressão: "if true 10 20"
testIf :: IO ()
testIf = do
  putStrLn "\nTest 6 - If (if true 10 20):"
  print $ evalStr "if true 10 20"

-- Test 7: Lam - Função lambda
-- Expressão: "\\x : Num -> x * 2"
testLam :: IO ()
testLam = do
  putStrLn "\nTest 7 - Lam (\\x : Num -> x * 2):"
  print $ evalStr "\\x : Num -> x * 2"

-- Test 8: Num - Número inteiro
-- Expressão: "42"
testNum :: IO ()
testNum = do
  putStrLn "\nTest 8 - Num (42):"
  print $ evalStr "42"

-- Test 9: Or - Disjunção lógica
-- Expressão: "false || true"
testOr :: IO ()
testOr = do
  putStrLn "\nTest 9 - Or (false || true):"
  print $ evalStr "false || true"

-- Test 10: Paren - Parênteses (agrupamento)
-- Expressão: "(5 + 3) * 2"
testParen :: IO ()
testParen = do
  putStrLn "\nTest 10 - Paren ((5 + 3) * 2):"
  print $ evalStr "(5 + 3) * 2"

-- Test 11: Proj - Projeção de tupla
-- Expressão: "{10, 20, 30}.2"
testProj :: IO ()
testProj = do
  putStrLn "\nTest 11 - Proj ({10, 20, 30}.2):"
  print $ evalStr "{10, 20, 30}.2"

-- Test 12: Sub - Subtração de números
-- Expressão: "10 - 3"
testSub :: IO ()
testSub = do
  putStrLn "\nTest 12 - Sub (10 - 3):"
  print $ evalStr "10 - 3"

-- Test 13: Times - Multiplicação de números
-- Expressão: "4 * 5"
testTimes :: IO ()
testTimes = do
  putStrLn "\nTest 13 - Times (4 * 5):"
  print $ evalStr "4 * 5"

-- Test 14: Tuple - Tupla de valores
-- Expressão: "{1, 2, 3}"
testTuple :: IO ()
testTuple = do
  putStrLn "\nTest 14 - Tuple ({1, 2, 3}):"
  print $ evalStr "{1, 2, 3}"

-- Test 15: Var - Variável (dentro de uma lambda aplicada)
-- Expressão: "(\\y : Num -> y) 7"
testVar :: IO ()
testVar = do
  putStrLn "\nTest 15 - Var ((\\y : Num -> y) 7):"
  print $ evalStr "(\\y : Num -> y) 7"

-- Test 16: Xor - Disjunção exclusiva
-- Expressão: "true xor false"
testXor :: IO ()
testXor = do
  putStrLn "\nTest 16 - Xor (true xor false):"
  print $ evalStr "true xor false"

-- =============================================================================
-- TESTE COMPLEXO USANDO TODAS AS 15 FUNCIONALIDADES
-- =============================================================================

-- Teste que combina todas as funcionalidades:
-- Expressão complexa em linguagem natural
testAllFeatures :: IO ()
testAllFeatures = do
  putStrLn "\n==============================================="
  putStrLn "TESTE COMPLEXO COM TODAS AS FUNCIONALIDADES"
  putStrLn "===============================================\n"

  let expr = "((\\f : (Num -> Num) -> if (true && (false || true)) ({((f 5)), ((10 - 3) * 2), (true xor false)}.1 + 8) 0) (\\x : Num -> x + 1))"
  putStrLn "Expressão complexa:"
  putStrLn expr
  putStrLn "\nResultado:"
  print $ evalStr expr

-- =============================================================================
-- MAIN - EXECUÇÃO DOS TESTES
-- =============================================================================

main :: IO ()
main = do
  putStrLn "==============================================="
  putStrLn "TESTES COM EXPRESSÕES EM LINGUAGEM NATURAL"
  putStrLn "===============================================\n"

  testAdd
  testAnd
  testApp
  testBFalse
  testBTrue
  testIf
  testLam
  testNum
  testOr
  testParen
  testProj
  testSub
  testTimes
  testTuple
  testVar
  testXor

  testAllFeatures

  putStrLn "\n==============================================="
  putStrLn "TODOS OS TESTES FORAM EXECUTADOS!"
  putStrLn "==============================================="
