module TypeChecker where

import Lexer

type Ctx = [(String, Ty)]

typeof :: Ctx -> Expr -> Maybe Ty
typeof ctx BTrue = Just TBool
typeof ctx BFalse = Just TBool
typeof ctx (Num n) = Just TNum
typeof ctx (Add e1 e2) =
  case (typeof ctx e1, typeof ctx e2) of
    (Just TNum, Just TNum) -> Just TNum
    _ -> Nothing
-- TypeOf para operador TIMES
typeof ctx (Times e1 e2) =
  case (typeof ctx e1, typeof ctx e2) of
    (Just TNum, Just TNum) -> Just TNum
    _ -> Nothing
-- TypeOf para operador AND
typeof ctx (And e1 e2) =
  case (typeof ctx e1, typeof ctx e2) of
    (Just TBool, Just TBool) -> Just TBool
    _ -> Nothing
-- TypeOf para Operador OR
typeof ctx (Or e1 e2) =
  case (typeof ctx e1, typeof ctx e2) of
    (Just TBool, Just TBool) -> Just TBool
    _ -> Nothing
-- TypeOf para operador IF
typeof ctx (If e e1 e2) =
  case typeof ctx e of
    Just TBool ->
      case (typeof ctx e1, typeof ctx e2) of
        (Just t1, Just t2)
          | t1 == t2 -> Just t1
          | otherwise -> Nothing
        _ -> Nothing
    _ -> Nothing
typeof ctx (Var x) = lookup x ctx
typeof ctx (Lam x tp b) =
  let ctx' = (x, tp) : ctx
   in case (typeof ctx' b) of
        Just tr -> Just (TFun tp tr)
        _ -> Nothing
typeof ctx (App e1 e2) =
  case typeof ctx e1 of
    Just (TFun tp tr) ->
      case typeof ctx e2 of
        Just t2
          | t2 == tp -> Just tr
          | otherwise -> Nothing -- professor nao implementou essa linha, então tambem posso remover do IF
        _ -> Nothing
    _ -> Nothing

typecheck :: Expr -> Expr
typecheck e = case typeof [] e of
  Just _ -> e
  Nothing -> error "Type error!"

-- case typeof ((x, tp) : ctx) b of
--   Just tb -> Just (TFun tp tb)
--   Nothing -> Nothing

-- typeof [] (Lam "x" TBool (Add (Var "x") (Num 2))) -> Nothing, pois tenta somar TBool com TNum
-- typeof [] (App (Lam "x" TNum (Add (Var "x") (Num 2))) (Num 3)) -> Just TNum