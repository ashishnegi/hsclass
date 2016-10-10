module Lesson3 where

-- This is thinking in terms of Types.. :)

-- Q. can you write a type for failure cases and also gives a failure message ??
-- <your code here>

-- What follows has been taken from :
-- "Making Impossible States Impossible" by Richard Feldman
-- https://www.youtube.com/watch?v=IcgmSRJHu_8

-- so, we want to model a survey :
-- survey has questions, and as user/teacher is going through them some of it has answers and others donot.
-- some user / student => answering the survey

type Prompt = String -- "What is 2  + 2 ?"
type Answer = String -- "4"
data Survey1 = Survey1 { prompts :: [ Prompt ]
                       , answers :: [ Answer ]
                       }

-- Which prompt belong to answer ? := 1st Prompt belong to 1st Answer
-- Length problem ..








-- done :)
-- but : sobody can create object of Survey1
survey1 = Survey1 [] ["bad-state-answer"]










-- we have a answer without a question.. :(
-- what do we do ??

-- <<< lines >>>>
data Question = Question { prompt :: Prompt
                         , answer :: Answer
                         }

data Survey2 = Survey2 { questions :: [ Question ] }
-- now that problem is solved.. :)
-- this is also what we learned in OOPs as well.


-- now user wants to go back and forth in the questions

data Survey3 = Survey3 { questions3 :: [ Question ]
             -- i had to use questions3 (and not questions) because current version
             -- of compiler does not allow same field names in one file.. (reason-1 at the bottom)
                       , current    :: Question
                       }


survey3 = Survey3 [] (Question "q1" "a1")
-- i.e. no questions, but current is something :(

















-- <<< lines >>>>
data Survey4 = Survey4 { first         :: Question
                       , restQuestions :: [ Question ]
                       , currentQ      :: Question
                       }
-- now we can not have empty list of questions
survey4 = Survey3 [Question "q1" "a1"] (Question "some-other-question" "a1")
-- but now current is not in the list.. bad data..
-- is it possible to avoid this ??

-- <<< lines >>>
data Survey = Survey { previousQuestions :: [ Question ]
                     , currentQuestion   :: Question
                     , nextQuestions     :: [ Question ]
                     }
-- all problems solved  :) :) :) !!!!

-- Thinking in types.. :) :) :) !!!!

-- Question :
-- while creating the survey, you show some messages to creator
-- creator can also delete a message.
-- Think about type for Status messages to show on UI
-- where you can have
--  1. no-message
--  2. text-message
--  3. delete-text-message with question to restore
-- uncomment this line.

-- data StatusMessage = -- < your code here >

-- Question :
-- create a binary search tree.
-- make it generic to take both Int and String


-- Question :
-- You have a todo list.
-- You need to have a user event where he can ask you to
-- show All tasks or Active tasks or Completed tasks.
-- data Visibility = -- < your code here >


-- Question :
-- rewrite User type above to allow Anonymous users in the system.
-- data User2 = -- < your code here >

-- reasons :
-- (reason-1) : google it out :)











































-- (Binary Tree) has a "Node" with (Int) and (Left and Rigth "Binary Tree")
-------              Or it can be ("Empty")

--             BinTree
--       Node |  Int  |
-- BinTree <--         --> BinTree

-- data BinTree = ??

data IntList = Empty | Cons Int IntList deriving Show

absAll :: IntList -> IntList
absAll Empty       = Empty
absAll (Cons x xs) = Cons (abs x) (absAll xs)

squareAll :: IntList -> IntList
squareAll Empty       = Empty
squareAll (Cons x xs) = Cons (x*x) (squareAll xs)

exampleList = Cons (-1) (Cons 2 (Cons (-6) Empty))

addOne x = x + 1
square x = x * x

-- mapIntList = ??
-- mapIntList addOne exampleList
-- mapIntList abs    exampleList
-- mapIntList square exampleList

keepOnlyEven :: IntList -> IntList
keepOnlyEven Empty = Empty
keepOnlyEven (Cons x xs)
  | even x    = Cons x (keepOnlyEven xs)
  | otherwise = keepOnlyEven xs

-- filterIntList = ??

-- How to represent a List which can not be empty ?
-- data NonEmptyList a = ??

-- Exercises from : http://www.cis.upenn.edu/~cis194/spring13/hw/03-rec-poly.pdf
-- The output of skips
-- is a list of lists. The first list in the output should
-- be the same as the input list. The second list in the output should
-- contain every second element from the input list. . . and the nth in list in
-- the output should contain every nth element from the input list.
-- For example:
-- skips "ABCD"       == ["ABCD", "BD", "C", "D"]
-- skips "hello!"     == ["hello!", "el!", "l!", "l", "o", "!"]
-- skips [1]          == [[1]]
-- skips [True,False] == [[True,False], [False]]
-- skips []           == []
-- Note that the output should be the same length as the input.
skips :: [a] -> [[a]]
skips _ = undefined

-- Exercise2
-- Local maxima A local maximum of a list is an element of the list which is strictly
-- greater than both the elements immediately before and after it. For
-- example, in the list [2,3,4,1,5], the only local maximum is 4
-- Write a function
-- localMaxima :: [Integer] -> [Integer]
-- which finds all the local maxima in the input list and returns them in
-- order. For example:
-- localMaxima [2,9,5,6,1] == [9,6]
-- localMaxima [2,3,4,1,5] == [4]
-- localMaxima [1,2,3,4,5] == []
localMaxima :: [Integer] -> [Integer]
localMaxima list = undefined
