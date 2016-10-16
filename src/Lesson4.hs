module Lesson4 where

import qualified Data.List as DL
import Data.Maybe (fromJust)
import Debug.Trace

-- http://www.cis.upenn.edu/~cis194/spring13/lectures/04-higher-order.html

-- Wholemeal programming
-- Let’s put some of the things we’ve just learned together in an example that also shows the
-- power of a “wholemeal” style of programming. Consider the function foobar, defined as follows:

foobar :: [Integer] -> Integer
foobar []     = 0
foobar (x:xs)
  | x > 3     = (7*x + 2) + foobar xs
  | otherwise = foobar xs

-- Instead of thinking about what we want to do with each element, we can instead think
-- about making incremental transformations to the entire input, using the existing recursion patterns
-- that we know of. Here’s a much more idiomatic implementation of foobar:

foobar' :: [Integer] -> Integer
foobar' _ = undefined

-- How to find functions / search in hoogle ?

-- From type signature : most useful.
-- https://www.haskell.org/hoogle/?hoogle=(a->a)->a->[a]
-- https://www.haskell.org/hoogle/?hoogle=%28a-%3Ea%29-%3Ea-%3E%5Ba%5D

-- From function name:
-- https://www.haskell.org/hoogle/?hoogle="<function-name>"
-- https://www.haskell.org/hoogle/?hoogle=iterate

-- How to read the docs ?
-- just read it.. :P http://hackage.haskell.org/package/base-4.9.0.0/docs/Prelude.html#v:iterate


-- foldl vs foldl' vs foldr
-- Folding is reducing.
-- You can reduce a list by summing all the numbers in it.
sumList = foldl (+) 0 [1..100]

-- you can start reducing a list from LEFT or RIGHT
-- and hence foldl and foldr

-- tip : foldl' and foldr
-- foldl is not useful
-- More about this when we talk about laziness..

data Tree a = Leaf
            | Node (Tree a) a (Tree a)
              deriving (Show, Eq)

-- insertIntoTree :: Tree a -> Key -> Value -> ??
-- insertIntoTree :: (Eq a, Ord a) => Tree a -> a -> Tree a
insertIntoTree :: (Eq a, Ord a) => a -> Tree a -> Tree a
insertIntoTree value tree =
  case tree of
    Leaf ->
      Node Leaf value Leaf
    Node left curr right ->
      if curr < value
      then Node left curr (insertIntoTree value right)
      else
      if curr == value
      then Node left value right
      else Node (insertIntoTree value left) curr right

treeFromList :: (Eq a, Ord a) => [ a ] -> Tree a
treeFromList as = DL.foldl' (flip insertIntoTree) Leaf as

treeWorks = treeFromList [2,4,10,1,-9,0,6,3]

unbalancedTree = treeFromList [1..10]

data BalancedTree a = BLeaf
                    | BNode Int (BalancedTree a) a (BalancedTree a)
                      deriving (Show, Eq)

heightOfBTree :: BalancedTree a -> Int
heightOfBTree tree =
  case tree of
    BLeaf -> 0
    BNode h _ _ _ -> h

insertIntoBTree :: (Eq a, Ord a) => a -> BalancedTree a -> BalancedTree a
insertIntoBTree value tree =
  case tree of
    BLeaf ->
      BNode 1 BLeaf value BLeaf
    node@(BNode height left curr right) ->
      let leftHeight = heightOfBTree left
          rightHeight = heightOfBTree right
      in
        if curr == value
        then node
        else let (l, c, r) = if curr < value
                             then -- we need to insert into rightTree and leftTree has more height -- so no need to balance
                               if leftHeight >= rightHeight
                               then (left, curr, (insertIntoBTree value right))
                               else
                                 let (Just newCurr, rightWithOneLessElement) = removeSmallestValueInTree right
                                 in ((insertIntoBTree curr left), (min value newCurr), (insertIntoBTree (max value newCurr) rightWithOneLessElement))
                             else
                               if leftHeight <= rightHeight
                               then ((insertIntoBTree value left), curr, right)
                               else
                                 let (Just newCurr, leftWithOneLessElement) = removeLargestValueInTree left
                                 in ((insertIntoBTree (min value newCurr) leftWithOneLessElement), (max value newCurr), (insertIntoBTree curr right))
             in BNode (1 + max (heightOfBTree l) (heightOfBTree r)) l c r


removeSmallestValueInTree :: (Eq a, Ord a) => BalancedTree a -> (Maybe a, BalancedTree a)
removeSmallestValueInTree tree =
  case tree of
    BLeaf -> (Nothing, BLeaf)
    BNode _ left c right ->
      case left of
        BLeaf -> (Just c, right)
        BNode _ _ _ _ ->
          let (c', left') = removeSmallestValueInTree left
          in (c', BNode (1 + max (heightOfBTree left') (heightOfBTree right)) left' c right)

removeLargestValueInTree :: (Eq a, Ord a) => BalancedTree a -> (Maybe a, BalancedTree a)
removeLargestValueInTree tree =
  case tree of
    BLeaf -> (Nothing, BLeaf)
    BNode _ left c right ->
      case right of
        BLeaf -> (Just c, left)
        BNode _ _ _ _ ->
          let (c', right') = removeLargestValueInTree right
          in (c', BNode (1 + max (heightOfBTree left) (heightOfBTree right')) left c right')

deleteTopElement :: (Eq a, Ord a) => BalancedTree a -> (Maybe a, BalancedTree a)
deleteTopElement tree =
  case tree of
    BLeaf -> (Nothing, BLeaf)
    node@(BNode h l c r) ->
      (Just c, treeWithOneLessElement node)
  where
    treeWithOneLessElement node =
      case node of
       BLeaf -> BLeaf
       BNode h l c r ->
         if (heightOfBTree l < heightOfBTree r)
         then
           let (Just newCurr, rt) = deleteTopElement r
           in BNode (h - 1) l newCurr rt
         else
           case deleteTopElement l of
             (Nothing, lt) -> lt
             (Just newCurr, lt) ->
               BNode (h - 1) lt newCurr r

bTreeFromList xs = DL.foldl' (flip insertIntoBTree) BLeaf xs

bTreeWorks = bTreeFromList [2,4,10,1,-9,0,6,3]

balancedTree = bTreeFromList [1..10]

bTreeToList :: BalancedTree a -> [ a ]
bTreeToList tree =
  case tree of
    BLeaf -> []
    BNode _ l c r ->
      bTreeToList l ++ [c] ++ bTreeToList r

test1 = do
  putStrLn "Unbalanced Tree:"
  putStrLn (show unbalancedTree)
  putStrLn "Balanced Tree: "
  putStrLn (show balancedTree)
