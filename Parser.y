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
    var             { TokenVar $$ }
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
    '\\'            { TokenLam }
    "->"            { TokenArrow }
    Bool            { TokenBool }
    Num             { TokenNumber }
    ':'             { TokenColon }

%%



Exp     : num                           { Num $1 }
        | var                           { Var $1 }
        | true                          { BTrue }
        | false                         { BFalse }
        | Exp '+' Exp                   { Add $1 $3 }
        | Exp '*' Exp                   { Times $1 $3 }
        | Exp "&&" Exp                  { And $1 $3 }
        | Exp "||" Exp                  { Or $1 $3 }
        | '(' Exp ')'                   { Paren $2 }
        | 'if' Exp Exp Exp              { If $2 $3 $4 }
        | '{' ExpList '}'               { Tuple $2 }
        | '{' '}'                       { Tuple [] }
        | Exp '.' num                   { Proj $1 $3 }
        | '\\' var ':' Type "->" Exp    { Lam $2 $4 $6 } -- (\\x : TNum -> 5 + x)

ExpList : Exp                           { [$1] }
        | Exp ',' ExpList               { $1 : $3 }


Type    : Bool                          { TBool }
        | Num                           { TNum }
        | Type "->" Type                { TFun $1 $3 }
        -- | '{' TypeList '}'              { TTuple $2 }
        | '{' '}'                       { TTuple [] }


--  eval (parser (lexer "(\\x : Num -> (5*5+x)) 5"))

{

parseError :: [Token] -> a
parseError _ = error "Syntax error!"

}
