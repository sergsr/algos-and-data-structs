{-# LANGUAGE DeriveFunctor, DeriveFoldable, DeriveTraversable #-}

-- | Binary tree implementation
module BinTree where
import Data.Traversable

-- * Constructors, accessors, conveniences
data Tree a = E | N {val :: a , left :: Tree a, right :: Tree a}
            deriving(Show, Functor, Foldable, Traversable)

type Forest a = [Tree a]

children :: Tree a -> Forest a
children (N _ l r) = [l,r]
children _         = []

-- * Typeclass instances
instance Applicative Tree where
  pure x = N x E E
  E           <*> _ = E
  _           <*> E = E
  (N f lf rf) <*> (N x l r) = undefined
-- TODO: need to figure out what exactly applicative does to a binary tree with
-- data in non-leafs (look at Data.Tree, unlist it)

-- * Traversals

-- ** BFS / Level order
-- | Breadth first search list of tree elements
bfs :: Tree a -> [a]
bfs t = bfsF [t]

-- | Breadth first search of forest elements
bfsF :: Forest a -> [a]
bfsF [] = []
bfsF ts = map val ts ++ bfsF (concatMap children ts)

-- | Asymmetric unfold (children values generated by two different functions)
asymUnfold :: (a -> a) -> (a -> a) -> a -> Tree a
asymUnfold lf rf s = N s (asymUnfold lf rf (lf s)) (asymUnfold lf rf (rf s))

inorder :: Tree a -> [a]
inorder E         = []
inorder L v       = [v]
inorder (N v l r) = inorder l ++ [v] ++ inorder r

preorder :: Tree a -> [a]
preorder E         = []
preorder (L v)       = [v]
preorder (N v l r) = v:preorder l ++ preorder r

postorder :: Tree a -> [a]
postorder E = []
postorder (L v) = [v]
postorder (N v l r)

unfold :: (a -> a) -> (a -> a) -> a -> Tree a
unfold lf rf s = N s (unfold lf rf (lf s)) (unfold lf rf (rf s))

-- | Symmetric unfold (children values generated using same function)
symUnfold :: (a -> a) -> a -> Tree a
symUnfold f = asymUnfold f f
