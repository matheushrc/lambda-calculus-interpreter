{
module Parser where

import Lexer
}

%name parser
%tokentype { Token }
%error { parseError }

-- Precedence order: lower priority rules first
%right lambda
%left "||"
%left "&&"
%left '+' '-'
%left '*'
%left APP

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
    var             { TokenVar $$ }
    lambda          { TokenLam }
    ':'             { TokenColon }
    '->'            { TokenArrow }
    tnum            { TokenTNum }
    tbool           { TokenTBool }


%%

Exp     : num              { Num $1 }
        | true             { BTrue }
        | false            { BFalse }
        | var              { Var $1 }
        | lambda var ':' Type '.' Exp { Lam $2 $4 $6 }
        | Exp Exp %prec APP { App $1 $2 }
        | Exp '+' Exp      { Add $1 $3 }
        | Exp '*' Exp      { Times $1 $3 }
        | Exp "&&" Exp     { And $1 $3 }
        | Exp "||" Exp     { Or $1 $3 }
        | '(' Exp ')'      { Paren $2 }
        | 'if' Exp Exp Exp { If $2 $3 $4 }
        | '{' ExpList '}'  { Tuple $2 }
        | '{' '}'          { Tuple [] }
        | Exp '.' num      { Proj $1 $3 }

Type    : tnum             { TNum }
        | tbool            { TBool }
        | Type '->' Type   { TFun $1 $3 }
        | '(' Type ')'     { $2 }

ExpList : Exp              { [$1] }
        | Exp ',' ExpList  { $1 : $3 }

{

parseError :: [Token] -> a
parseError _ = error "Syntax error!"

}
