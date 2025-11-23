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
-- TypeOf for Paren
typeof ctx (Paren e) = typeof ctx e
typeof ctx (Var x) = lookup x ctx
typeof ctx (Lam x tp b) =
  let ctx' = (x, tp) : ctx
   in case (typeof ctx' b) of
        Just tr -> Just (TFun tp tr) -- tr = type result; tp = type parameter
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
-- TypeOf for Tuple (T-Tuple rule)
typeof ctx (Tuple exprs) =
  let types = map (typeof ctx) exprs
   in if all isJust types
        then Just (TTuple (map fromJust types))
        else Nothing
  where
    isJust (Just _) = True
    isJust Nothing = False
    fromJust (Just x) = x
    fromJust Nothing = error "Impossible"
-- TypeOf for Projection (T-Proj rule)
typeof ctx (Proj e idx) =
  case typeof ctx e of
    Just (TTuple types) ->
      if idx >= 1 && idx <= length types
        then Just (types !! (idx - 1)) -- Convert 1-based to 0-based indexing
        else Nothing
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