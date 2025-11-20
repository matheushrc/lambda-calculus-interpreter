module Interpreter where

import Lexer (Expr (Add, And, App, BFalse, BTrue, If, Lam, Num, Or, Times, Var))
import Parser

isValue :: Expr -> Bool
isValue BTrue = True
isValue BFalse = True
isValue (Num _) = True
isValue (Lam _ _ _) = True
isValue _ = False

subst :: String -> Expr -> Expr -> Expr
subst x s y@(Var v) =
  if x == v
    then
      s
    else y
-- substituir o x pelo n numa expressao que tem um lambda
subst x s (Num n) = Num n -- (\x -> 2) 5, não há substituição a ser feita, pois o x é uma constante, não ha nada para substituir dentro do corpo da lambda
subst x s BTrue = BTrue
subst x s BFalse = BFalse
subst x s (Lam y tp t1) = Lam y tp (subst x s t1)
-- eu tenho que procura a substituiição tambem da exprassao t1 da lambda, por isso eu realizo a chamada recursiva
subst x s (App t1 t2) = App (subst x s t1) (subst x s t2)
subst x s (Add t1 t2) = Add (subst x s t1) (subst x s t2)
subst x s (And t1 t2) = And (subst x s t1) (subst x s t2)

-- subst "x" (Num 2) (Lam "y" (Var "x")) -> Lam "y" (Num 2)
-- subst "x" (Num 2) (App (Lam "y" (Var "x")) (Var "x")) ->
-- example with two lambdas
-- subst "x" (Lam "z" (Var "z")) (App (Lam "y" (Var "x")) (Var "x"))

-- subst de if tem 3 coisas
-- subst de times, or, if

step :: Expr -> Expr
step (Add (Num n1) (Num n2)) = Num (n1 + n2)
-- step (Add (Num n1) e2) = Add (Num n1) (step e2)
step (Add (Num n1) e2) =
  let e2' = step e2
   in Add (Num n1) e2'
step (Add e1 e2) = Add (step e1) e2
-- mais especifica para que aceita mais coisas
step (And BFalse e2) = BFalse
step (And BTrue e2) = e2
-- eu resolvo para e1 primeiro pois e1 ja tem casos base para BTrue e BFalse, como aqui é apenas um step, eu deixo para o proximo step e2' resolver e2
step (And e1 e2) = And (step e1) e2
-- Implementar step para Or
step (Or BTrue e2) = BTrue
step (Or BFalse e2) = e2
step (Or e1 e2) = Or (step e1) e2
-- Implementar step para Times
step (Times (Num n1) (Num n2)) = Num (n1 * n2)
step (Times (Num n1) e2) =
  let e2' = step e2
   in Times (Num n1) e2'
step (Times e1 e2) = Times (step e1) e2
-- Implementar step para If
-- slide 10
step (App (Lam x tp e1) e2) =
  if isValue e2
    then
      subst x e2 e1 -- trata isso (\x -> x + 1) 2
    else App (Lam x tp e1) (step e2) -- trata isso (\x -> x + 1) (2 + 3)
step (If BTrue e1 e2) = e1
step (If BFalse e1 e2) = e2
step (If e e1 e2) = If (step e) e1 e2

-- step (App (Lam "x" (Add (Var "x") (Num 1))) (Num 2))
-- step (App (Lam "x" (Add (Var "x") (Num 1))) (Add (Num 2) (Num 3)))
eval :: Expr -> Expr
eval e =
  if isValue e
    then
      e
    else
      eval (step e)