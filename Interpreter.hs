module Interpreter where

import Lexer (Expr (Add, And, App, BFalse, BTrue, If, Lam, Num, Or, Paren, Proj, Times, Tuple, Var))
import Parser

isValue :: Expr -> Bool
isValue BTrue = True
isValue BFalse = True
isValue (Num _) = True
isValue (Lam _ _ _) = True
isValue (Tuple exprs) = all isValue exprs
isValue (Paren e) = isValue e
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
subst x s (Lam y tp t1) =
  if x == y
    then Lam y tp t1  -- Variable shadowing: don't substitute
    else Lam y tp (subst x s t1)
-- eu tenho que procura a substituiição tambem da exprassao t1 da lambda, por isso eu realizo a chamada recursiva
subst x s (App t1 t2) = App (subst x s t1) (subst x s t2)
subst x s (Add t1 t2) = Add (subst x s t1) (subst x s t2)
subst x s (And t1 t2) = And (subst x s t1) (subst x s t2)
subst x s (Or t1 t2) = Or (subst x s t1) (subst x s t2)
subst x s (Times t1 t2) = Times (subst x s t1) (subst x s t2)
subst x s (If t1 t2 t3) = If (subst x s t1) (subst x s t2) (subst x s t3)
subst x s (Tuple exprs) = Tuple (map (subst x s) exprs)
subst x s (Proj e idx) = Proj (subst x s e) idx
subst x s (Paren e) = Paren (subst x s e)

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
-- E-App1: evaluate e1 first if it's not a lambda
step (App e1 e2) =
  let e1' = case e1 of
              Paren e -> e  -- Unwrap Paren
              _ -> e1
  in if isValue e1'
    then case e1' of
      (Lam x tp body) ->
        if isValue e2
          then subst x e2 body  -- E-AppAbs: beta reduction
          else App e1' (step e2) -- E-App2: evaluate e2
      _ -> error "Runtime error: trying to apply non-function"
    else App (step e1) e2       -- E-App1: evaluate e1
-- Implementar step para If
-- slide 10
step (If BTrue e1 e2) = e1
step (If BFalse e1 e2) = e2
step (If e e1 e2) = If (step e) e1 e2

-- E-ProjTuple: {v1, ..., vn}.j -> vj
step (Proj (Tuple exprs) idx) =
  if all isValue exprs
    then exprs !! (idx - 1) -- 1-based to 0-based indexing
    else Proj (step (Tuple exprs)) idx
-- E-Proj: t1 -> t1' implies t1.i -> t1'.i
step (Proj e idx) = Proj (step e) idx
-- E-Tuple: evaluate tuple elements left-to-right
step (Tuple exprs) = Tuple (stepTupleElements exprs)
  where
    stepTupleElements [] = []
    stepTupleElements (e:es) =
      if isValue e
        then e : stepTupleElements es
        else step e : es
-- step for Paren
step (Paren e) = e
-- If we reach here with a value or variable, something went wrong
step (Var x) = error $ "Runtime error: free variable " ++ x
step e | isValue e = e  -- Already a value, no step needed
       | otherwise = error $ "Runtime error: cannot step expression"
-- step (App (Lam "x" (Add (Var "x") (Num 1))) (Num 2))
-- step (App (Lam "x" (Add (Var "x") (Num 1))) (Add (Num 2) (Num 3)))
eval :: Expr -> Expr
eval e =
  if isValue e
    then
      e
    else
      eval (step e)