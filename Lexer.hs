module Lexer where

import Data.Char

data Token
  = TokenNum Int
  | TokenTrue
  | TokenFalse
  | TokenPlus
  | TokenMinus
  | TokenTimes
  | TokenAnd
  | TokenOr
  | TokenXor
  | TokenLParen
  | TokenRParen
  | TokenIf
  | TokenVar String
  | TokenLam
  | TokenApp
  | TokenLBrace
  | TokenRBrace
  | TokenDot
  | TokenComma
  | TokenArrow
  | TokenBool
  | TokenNumber
  | TokenColon
  deriving (Show)

data Expr
  = Num Int
  | BTrue
  | BFalse
  | Add Expr Expr
  | Sub Expr Expr
  | Times Expr Expr
  | And Expr Expr
  | Or Expr Expr
  | Xor Expr Expr
  | Paren Expr
  | If Expr Expr Expr
  | Var String
  | Lam String Ty Expr
  | App Expr Expr
  | Tuple [Expr]
  | Proj Expr Int
  deriving (Show)

data Ty
  = TNum
  | TBool
  | TFun Ty Ty
  | TTuple [Ty]
  deriving (Show, Eq)

lexer :: String -> [Token]
lexer [] = []
lexer ('-' : '>' : cs) = TokenArrow : lexer cs
lexer ('+' : cs) = TokenPlus : lexer cs
lexer ('-' : cs) = TokenMinus : lexer cs
lexer ('*' : cs) = TokenTimes : lexer cs
lexer ('(' : cs) = TokenLParen : lexer cs
lexer (')' : cs) = TokenRParen : lexer cs
lexer ('{' : cs) = TokenLBrace : lexer cs
lexer ('}' : cs) = TokenRBrace : lexer cs
lexer ('.' : cs) = TokenDot : lexer cs
lexer (',' : cs) = TokenComma : lexer cs
lexer (':' : cs) = TokenColon : lexer cs
lexer ('&' : '&' : cs) = TokenAnd : lexer cs
lexer ('|' : '|' : cs) = TokenOr : lexer cs
lexer ('\\' : cs) = TokenLam : lexer cs
lexer (c : cs)
  | isSpace c = lexer cs
  | isDigit c = lexNum (c : cs)
  | isAlpha c = lexKw (c : cs)
lexer _ = error "Lexical error"

lexNum cs = case span isDigit cs of
  (num, rest) -> TokenNum (read num) : lexer rest

lexKw cs = case span isAlpha cs of
  ("true", rest) -> TokenTrue : lexer rest
  ("false", rest) -> TokenFalse : lexer rest
  ("if", rest) -> TokenIf : lexer rest
  ("xor", rest) -> TokenXor : lexer rest
  ("app", rest) -> TokenApp : lexer rest
  ("Bool", rest) -> TokenBool : lexer rest
  ("Num", rest) -> TokenNumber : lexer rest
  (var, rest) -> TokenVar var : lexer rest
