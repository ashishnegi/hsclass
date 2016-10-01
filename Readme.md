# HSClass : Haskell Class with friends..

Following :

1. http://www.cis.upenn.edu/~cis194/spring13/
2. http://learnyouahaskell.com/
3. http://guide.elm-lang.org/ ( sometimes elm explains it better :) )

## Setup :
1. Install Stack : `brew install haskell-stack` . For brew see: `http://brew.sh/`
2. Better fork this project and `git clone git@github.com/<your-name>/hsclass`
4. `stack build --fast --file-watch` # compiles automatically the code changes.
3. start hacking in app/Main.hs -- do all the exercises. Future exercises will go to src/Lession*.hs
4. `Atom` ide is good for haskell development.
5. Emacs users can use `intero` mode : https://commercialhaskell.github.io/intero/

## Workflow
1. If you are using `stack build` command, as you write code, you will get
   compiler warnings.
2. Fix all the compiler warnings.
3. In terminal, run `stack exec <exe-name>` where
   `<exe-name>` is present in `<project>.cabal` file under `executable`.
   for e.g. this project the line is : `executable hsclass-exe`.
4. Repl driven development :
   As you are writing code, you can start a repl and load your files in it.
   `stack repl` will start a repl.
   type `:l <path-of-file>` like `:l app/Main.hs`
   All functions in `Main.hs` are now available to you.
   for e.g. `main` would run the main function in `Main.hs``.
5. You can write multi line code in repl by enclosing them in `{ <your code> }` as :

   ```
   *Main> :set +m -- for multiline coding.
   *Main> { foo :: Int -> Int;
   *Main| foo a = a + 1; }
   *Main> foo 2
   3
   *Main>
   ```
6. To quit repl, use `:q`
7. You can see all commands with `:?`

### A snapshot of REPL
```
➜  hsclass git:(master) ✗ stack repl
The following GHC options are incompatible with GHCi and have not been passed to it: -threaded
Using main module: 1. Package `hsclass' component exe:hsclass-exe with main-is file: /Users/ashishnegi/gitprojs/hsclass/app/Main.hs
Configuring GHCi with the following packages: hsclass
GHCi, version 8.0.1: http://www.haskell.org/ghc/  :? for help
[1 of 1] Compiling Lib              ( /Users/ashishnegi/gitprojs/hsclass/src/Lib.hs, interpreted )
Ok, modules loaded: Lib.
[2 of 2] Compiling Main             ( /Users/ashishnegi/gitprojs/hsclass/app/Main.hs, interpreted )
Ok, modules loaded: Lib, Main.
Loaded GHCi configuration from /private/var/folders/y4/lqw1l0296r7__gsc62yltgs40000gn/T/ghci76597/ghci-script
*Main Lib> :l app/Main.hs
[1 of 1] Compiling Main             ( app/Main.hs, interpreted )
Ok, modules loaded: Main.
*Main> main
Hello world
1
[1,2,3]
True
*Main> :t main
main :: IO ()
*Main> :i main
main :: IO () 	-- Defined at app/Main.hs:49:1
*Main> import Data.List
*Main Data.List> filter (> 1) [1, 2, 3]
[2,3]
*Main Data.List> { foo :: Int -> Int;

<interactive>:11:21: error:
    parse error (possibly incorrect indentation or mismatched brackets)
*Main Data.List> :set +m
*Main Data.List> { foo :: Int -> Int;
*Main Data.List| foo a = a + 1; }
*Main Data.List> foo 1
2
*Main Data.List> :t foo
foo :: Int -> Int
*Main Data.List> :q
Leaving GHCi.
➜  hsclass git:(master) ✗
```

Happy haskelling... :)