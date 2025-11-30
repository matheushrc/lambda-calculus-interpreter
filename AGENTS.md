# Instruction on Running the Interpreter

1. Build the project using

   ```pwsh
   ghc -o interpreter Main.hs
   ```

2. Run the interpreter with test inputs using

   ```pwsh
   .\interpreter.exe < test_input.txt
   ```

3. Never run commands using ghci, as it may lead to unexpected behavior.
