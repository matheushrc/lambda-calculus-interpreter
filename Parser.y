{
module Parser where 

import Lexer 
}

%name parser 
%tokentype { Token }
%error { parseError }

-- isso aqui é a ordem de precesencia, quanto mais abaixo primeiro é checada
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

{ 

parseError :: [Token] -> a 
parseError _ = error "Syntax error!"

}

-- implementar lambda calculus