{-
1. Using recursion and the function add, define a function that multiplies two natural numbers
2. A binary tree is complete if the two sub-trees of every node are of equal size. Define a function that decides if a binary tree is complete
3. Definire una funzione di ordine superiore foldExpr per le espressioni con la quale si possano definire le funzioni size e eval
-}

data Nat = Zero | Succ Nat deriving Show
data Tree a = Leaf a | Node (Tree a) a (Tree a)
data Expr = Val Int | Add Expr Expr | Mul Expr Expr 

one = Node (Leaf 1) 2 (Leaf 3)
two = Node (Node (Leaf 1) 2 (Leaf 3)) 4 (Leaf 5)
three = Node (Leaf 1) 2 (Node (Leaf 3) 4 (Leaf 5))
four = Add (Val 2) (Mul (Val 3) (Val 4))
five = Add (Mul (Val 3) (Val 6)) (Add (Mul (Val 4) (Val 5)) (Val 6))

nat2int :: Nat -> Int
nat2int Zero = 0
nat2int (Succ n) = 1 + nat2int n

int2nat :: Int -> Nat
int2nat 0 = Zero
int2nat n = Succ (int2nat (n - 1))

add Zero b = b
add (Succ a) b = Succ (add b a)

molt Zero _ = Zero
molt _ Zero = Zero
molt (Succ a) b = add b (molt a b)

size (Leaf _) = 1
size (Node a _ c) = size a + size c 

complete (Leaf _) = True
complete (Node a _ c) = and [(size a == size c), complete a, complete c]

foldExpr fAdd fMul fVal (Val n) = fVal n
foldExpr fAdd fMul fVal (Add a b) = fAdd (foldExpr fAdd fMul fVal a) (foldExpr fAdd fMul fVal b)
foldExpr fAdd fMul fVal (Mul a b) = fMul (foldExpr fAdd fMul fVal a) (foldExpr fAdd fMul fVal b)

eval = foldExpr (+) (*) id

size = foldExpr (+) (+) (const 1)

