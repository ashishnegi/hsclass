module Lesson2 where
-- Here be types :)

-- Types are cheap in Haskell
-- In c++, java we need to have a reason to create class
-- but in haskell, there has to be a reason to not create type.

-- types can be written in 3 ways
-- 1. type : gives another name to a type
--    makes it readable.
-- type alias
type NumThreads1 = Int
type MaxDepthToCrawl1 = Int

foo :: NumThreads1 -> MaxDepthToCrawl1 -> Int
foo numThreads depth = numThreads

v = foo 0 1
-- compiler will not give any error :
-- CrawlConfig 1 0 ;; CrawlConfig 0 1
-- foo :: NumThreads -> ...
-- compiler will give error :

-- 2. data : to make a type
-- LHS = RHS
-- LHS User => Type COnstructor
-- RHS User => Data Constructor
-- Values of User => Values (name) * Values (age)
-- Product Types / Sum types
data User = User
            { name :: String -- name :: User -> String
            , age  :: Int
            }

-- note: this `{ .. }` is also called Record Syntax.

-- another example of `data`
-- Enumeration only.. // Union Type // Sum types
-- Value is Run time // Type is compile time
-- Day is Monday OR Tuesday OR ....
data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
-- 3. since "data" makes a wrapper over basic data type,
--    we can use "newtype" for getting benefit of types but no performance penalty
newtype Msg = Msg String
newtype NumThreads = NumThreads Int
-- CrawlConfig (NumThreads 1) (MaxDepthToCrawl 1) ;;
-- CrawlConfig 1 1 ;; Type error while creating values..
-- age :: [ Int ] -- [ Age ] -- [ Int ]
-- Boxing / UnBoxing
-- CrawlConfig (MaxDepthToCrawl 1) (NumThreads 1)

-- If i give one `|` between messages i get the error
-- newtype Msg2 = Msg2 String | Msg3 String String
-- error:
--     • A newtype must have exactly one constructor, but ‘Msg2’ has two
--     • In the newtype declaration for ‘Msg2’

-- Use data > newtype > type
-- type makes it readable.
-- newtype gives us type helps and is performant but only one data constructor. (more about it next)
-- data gives us type helps and multiple data constructors.

-- Just like template classes in haskell, we can write
data List a = List    a      (List a) | Empty
              -- List 1  Empty
              -- List 1  (List 2 Empty)
              -- List 1  (List 2 (List 3 (List a)))

-- List needs a Type (Int/String) => new Type (List Int / List String)
-- List a is constructed by (List a ) and has More List type
-- List Int = List Int (List Int) | Empty
-- List String = List String (List String) | Empty

-- this can be written as
-- LHS                     =  RHS
data ListTypeConstructor a = ListDataConstructor a (ListTypeConstructor a) | EmptyC
data ListTC a = ListDC a (ListTC a) | EmptyCs
                -- EmptyCs
                -- ListDC 1  EmptyCs
                -- -- ListDC 1  (ListDC 2 (ListTC a)) -- REMOVE all TC / TypeConstructors
                -- ListDC 1  (ListDC 2 (ListDC 3 EmptyCs))
-- foo :: ListTypeConstructor Int -> Int
-- foo list = let listOfInts = ListDataConstructor 1 EmptyC

-- so what is type constructor
-- data constructor is used for creating actual data (run time)
-- type constructor is used for creating types (compile time)
-- so in right side of =, First thing is always DataConstructor (here ListDataConstructor)
-- in left side of =, it is always TypeConstructor (here ListTypeConstructor in left side of =)
-- at other places it is TypeConstructor (right side of = , see ListTypeConstructor)

-- since both DC and TC are in different namespace for compiler,
-- compiler does not have any problem if you give same name
-- as we did in `data List a = List a (List a)

-- Q. what is EmptyC ? is it EmptyDataConstructor or EmptyTypeConstructor ?

-- ok, now let us quickly, see usage of different types

-- see type signature of `fooThreads` : it is so much readable.
type ThreadId = Int
fooThreads :: NumThreads -> [ThreadId]
fooThreads a = [1,2,3]

-- will this be readable if it is
-- fooThreds2 :: Int -> [Int] ???
-- types are cheap, always give a name

-- data User = User
--             { name :: String -- name :: User -> String
--             , age  :: Int    -- age  :: User -> Int
--             }

-- see the pattern matching / destructuring
fooUserName :: User -> String
fooUserName (User name age) = name
-- name is a function actually
-- fooUserName user = (name user)

-- data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
-- what when you have `|` i.e. multiple DataConstructors,
-- you can not pattern match on the argument. You need to use `case <argument> of`
fooDayToInt :: Day -> Int
fooDayToInt day =
  case day of
    Monday    -> 0
    Tuesday   -> 1
    Wednesday -> 2
    Thursday  -> 3
    Friday    -> 4
    Saturday  -> 5
    Sunday    -> 6

-- and finally newtype
-- since they will always have one and only one data constructor (DC)
-- they can always be pattern matched in argument itself.. :)
fooMsgToString :: Msg -> String
fooMsgToString (Msg s) = s

data Book = Book Int
data Author = Author Book
-- Partial Function is NOT GOOD / BAD
-- increment :: Int -> Int
-- increment a = a + 1

-- Partial Function is NOT GOOD / BAD
-- authorFactory :: Book -> Author
-- authorFactory b@(Book bId) = if bId < 0
--                              then NoAuthor
--                              else (Author b)
-- bookFactory :: Int -> Book
-- bookFactory bId = if bId < 0
--                   then NoBook
--                   else (Book bId)

-- Author AuthorFactory(Book book) {
--    if (book.id < 0) {
--      throw IllegalAEce... ();
--      return null;
--      }
--    return new Author(book);;
-- }


-- So this is syntax..
-- lets start the philosophy :)

-- haskell does not have pointers, so no nulls and so null-pointer-exception and so less headache
-- BUT how do we then define some failure ?
-- in java, if our arguments are wrong, we can return null and that caller-of-function can take as
-- failure of function.. but since we have only Values in haskell, this is not possible..
-- so ??? create a type :)

data Result value = Ok value | Failed
     -- Result Author
     -- Result Book
authorFactory2 :: Book -> Result Author
authorFactory2 b@(Book bId) = if bId < 0
                             then Failed
                             else Ok (Author b)

bookFactory2 :: Int -> Result Book
bookFactory2 bId = if bId < 0
                  then Failed
                  else Ok (Book bId)
-- api route --- db call --
-- foo2 = let resultOfAuthor = authorFactory2 (Book 1) -- Result Author
--       in case resultOfAuthor of
--           Failed ->  Failed
--           Ok author -> fooAuthor author

-- fooAuthor :: Author -> Book
-- fooAuthor (Author book) = book

-- This is thinking in terms of Types.. :)

-- Q. can you write a type that fails and also gives a failure message ??
-- <your code here>

-- What follows has been taken from :
-- "Making Impossible States Impossible" by Richard Feldman
-- https://www.youtube.com/watch?v=IcgmSRJHu_8

-- so, we want to model a survey :
-- survey has questions, and as user is going through them some of it has answers and others donot.
type Prompt = String
type Answer = String
data Survey1 = Survey1 { prompts :: [ Prompt ]
                       , answers :: [ Answer ]
                       }

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
-- but now we can have problems of
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
