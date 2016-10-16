module Main where

import Test.Hspec
import Test.QuickCheck
import Data.List
import Lesson4 as L4

main :: IO ()
main = hspec $ do
  describe "insertions in balanced binary search tree " $ do
    it "inorder traversal of tree gives in sorted order" $
      property $ \ ints ->
        let xs = nub ints
            bTree = L4.bTreeFromList (xs :: [ Int ])
            inOrderTraversal = L4.bTreeToList bTree
        in sort xs == inOrderTraversal

  describe "deleteTopElment " $ do
    it "should not remove more than expected elements" $
      property $ \ ints ->
        let xs = nub ints
            bTree = L4.bTreeFromList (xs :: [ Int ])
            (a, bTreeWithOneLessElement) = L4.deleteTopElement bTree
            intsInTree = L4.bTreeToList bTreeWithOneLessElement

        in case a of
          Nothing -> (bTreeWithOneLessElement == BLeaf) && (length xs) <= 1
          Just x ->
            sort xs == sort (x : intsInTree)
