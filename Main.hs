module Main where

import Interpreter
import Lexer
import Parser
import TypeChecker

main = getContents >>= print . eval . typecheck . parser . lexer
