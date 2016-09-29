module Main where

-- How you are supposed to do this exercise ?
-- 1) Recursion : This is a powerful thing.
--    In haskell, you would see recursion at a lot of places.
--    and it is easier to do as well..
-- 2) writing sub-functions :

-- See this example ;
-- I have to write a function that give a number N
--   gives me a list that has N "Hello" strings.
-- Types says it all :)
sayNHello :: Int -> [String]
-- I will create a sub-function.. we use "where" for that..
sayNHello n = sayNHello' 0 n []
  where
    -- this is how you write sub-function
    -- we do not need to write types here as compiler derives it for us..
    -- but just for sanity
    sayNHello' :: Int -> Int -> [String] -> [String]
    sayNHello' i n resultSoFar =
      if i < n
      -- keep appending to the list if we are not done yet..
      then sayNHello' (i + 1) n ("Hello" : resultSoFar)
      else resultSoFar -- otherwise we are done..

--ghci >1234 `div` 10
--123
--ghci >1234 `div` 100
--12
--ghci >1234 `div` 1000
--1
--ghci >1234 `div` 10000
--0
myReverse :: [Integer] -> [Integer]
myReverse []  = []
myReverse xs = myReverseAcc xs []
  where 
    myReverseAcc (x:xs) acc = myReverseAcc xs (x:acc)
    myReverseAcc [] acc = acc

doubleAlts :: [Integer] -> [Integer]
doubleAlts [] = []
doubleAlts list  = doubleAltsCounter list 1
  where 
      doubleAltsCounter (x:xs) acc
        | acc `rem` 2 == 0 = x*2:doubleAltsCounter xs (acc+1)
        | otherwise = x:doubleAltsCounter xs (acc+1)
      doubleAltsCounter [] _ = []



numdigits :: Integer -> Int -> Int
numdigits cardNumber acc 
  | cardNumber `div` (10 ^ acc) == 0 = acc
  | otherwise = numdigits cardNumber (acc+1)


--ghci >1234 `rem` 1 0000  `div` 1000
--1
--ghci >1234 `rem` 1000 `div` 100
--2
--ghci >1234 `rem` 100 `div` 10
--3
--ghci >1234 `rem` 10 `div` 1
--4
toDigits :: Integer -> [Integer]
toDigits cardNumber
  | cardNumber == 0 = []
  | cardNumber < 0 = []

toDigits cardNumber = formula cardNumber 1 []
  where 
    formula cardNumber place acc 
      | place <= ndigits = formula cardNumber (place+1) (cardNumber `rem` (10 ^ place) `div` (10 ^ (place-1)):acc)
      | otherwise = acc
        where ndigits = numdigits cardNumber 1

toDigitsRev :: Integer -> [Integer]
toDigitsRev cardNumber
  | cardNumber == 0 = []
  | cardNumber < 0 = []
toDigitsRev cardNumber = formula cardNumber ndigits []
  where 
    formula cardNumber place acc 
      | place > 0 = formula cardNumber (place - 1) (cardNumber `rem` (10 ^ place) `div` (10 ^ (place-1)):acc)
      | otherwise = acc
    ndigits = numdigits cardNumber 1

-- You need to map over every element of the list..
-- But you can use recursion for it as well..
-- Otherwise you can write to the top of file after `module ..`
-- import qualified Data.List as DL
-- and use DL.map..
-- but remember it is all about writing Recursion at this point..
doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther =  myReverse . doubleAlts . myReverse

sumDigits :: [Integer] -> Integer
sumDigits [] = 0
sumDigits (x:xs) = x + sumDigits xs

validate :: Integer -> Bool
validate cardNumber 
  | mychecksum `rem` 10 == 0 = True
  | otherwise = False 
      where mychecksum = sumDigits $ doubleEveryOther $ toDigits $ cardNumber

main :: IO ()
main = do
  let cardNumber = 4622715351164531
  let thedigits = toDigits cardNumber
  putStrLn $ show $ thedigits
  let thedigitsrev = toDigitsRev cardNumber

  putStrLn $ show $ thedigitsrev
  putStrLn $ show $ doubleEveryOther thedigits
  putStrLn $ show $ sumDigits $ doubleEveryOther $ toDigits $ cardNumber
  putStrLn $ show $ validate cardNumber
 
 