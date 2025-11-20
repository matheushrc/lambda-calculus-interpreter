{
module Parser where

import Lexer
}

%name parser
%tokentype { Token }
%error { parseError }

-- Precedence order: lower priority rules first
%left '+' '-'
%left '*'

%token
    num             { TokenNum $$ }
    true            { TokenTrue }
    false           { TokenFalse }
    '+'             { TokenPlus }
    '*'             { TokenTimes }
    "&&"            { TokenAnd }
    "||"            { TokenOr }
    '('             { TokenLParen }
    ')'             { TokenRParen }
    'if'            { TokenIf }
    '{'             { TokenLBrace }
    '}'             { TokenRBrace }
    '.'             { TokenDot }
    ','             { TokenComma }


%%

Exp     : num              { Num $1 }
        | true             { BTrue }
        | false            { BFalse }
        | Exp '+' Exp      { Add $1 $3 }
        | Exp '*' Exp      { Times $1 $3 }
        | Exp "&&" Exp     { And $1 $3 }
        | Exp "||" Exp     { Or $1 $3 }
        | '(' Exp ')'      { Paren $2 }
        | 'if' Exp Exp Exp { If $2 $3 $4 }
        | '{' ExpList '}'  { Tuple $2 }
        | '{' '}'          { Tuple [] }
        | Exp '.' num      { Proj $1 $3 }

ExpList : Exp              { [$1] }
        | Exp ',' ExpList  { $1 : $3 }

{

parseError :: [Token] -> a
parseError _ = error "Syntax error!"

}
