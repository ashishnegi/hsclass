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
