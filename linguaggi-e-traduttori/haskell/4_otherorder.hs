{-
1. Write a function zipWith' with the following behavior: zipWith' (+) [4,2,5,6] [2,6,2,3]
2. Definire una funzione ordinato che fornisce valore vero se una lista e' ordinata, tramite zipWith
3. Si scriva una funzione di ordine superiore maxf che prende come parametri una funzione f e una lista xs e fornisce l'elemento x della
   lista xs che massimizza la funzione f (ossia il valore x per cui f(x) e' massimo)
4. Create a password strength checker using higher-order functions. A strong password has: at least 15 characters, uppercase, lowercase
   numbers
5. The function remdups removes adjacent duplicates from a list. Define remdups using foldr. Give another definition using foldl
6. Redefine map f and filter p using foldr
-}

zipWith' (_) [] ys = ys
zipWith' (_) xs [] = xs
zipWith' (f) (x : xs) (y : ys) = x `f` y : zipWith' (f) xs ys

ordinato xs = and (zipWith' (<) xs (tail xs))

maxf f (x : xs) = foldr (\a acc -> if f a > f acc then a else acc) x xs

strong xs = and [(length xs) >= 15, any (`elem` ['A'..'Z']) xs, any (`elem` ['a'..'z']) xs, any (`elem` ['0'..'9']) xs]

remdups xs = foldr f [] xs 
 where
   f x [] = [x]
   f x acc = if x == head acc then acc else x : acc

mappa f = foldr (\x acc -> f x : acc) [] 

filtra p = foldr (\x acc -> if p x then x : acc else acc) []

{-
7. Scrivere una funzione pitagorica che, dato un valore n, fornisce una lista di liste. La lista di liste rappresenta una matrice
   che contiene la tavola pitagorica fino a n
8. Scrivere una funzione contaMinuscoli che, data una stringa, fornisce il numero di caratteri minuscoli nella stringa
9. A triple (x,y,z) of positive integers is called pythagorean if x2 + y2 = z2. Using a list comprehension, define a function pyths 
   that maps an integer n to all such triples with components in [1..n]
10. A positive integer is perfect if it equals the sum of all of its factors, excluding the number itself. Using a list comprehension
    define a function perfects that returns the list of all perfect numbers up to a given limit
11. When the great Indian mathematician Srinivasan Ramanujan was ill in a London hospital, he was visited by the English mathematician 
    G.H. Hardy. Trying to find a subject of conversation, Hardy remarked that he had arrived in a taxi with the number 1729, a rather 
    boring number it seemed to him. Not at all, Ramanujan instantly replied, it is the first number that can be expressed as two cubes in 
    essentially different ways: 1^3 + 12^3 = 9^3 + 10^3 = 1729. Write a function that, given a number n, finds the list of all the 
    numbers <=n having the same property
-}

pitagorica n = [[x * y | y <- [1 .. n]] | x <- [1  .. n]]

contaMinuscoli xs = length [x | x <- xs, x `elem` ['a' .. 'z']]

pyths n = [(a, b, c) | a <- [1 .. n], b <- [a .. n], c <- [1 .. n], (a^2 + b^2) == c^2]

perfects n = [a | a <- [1 .. n], a == sum [b | b <- [1 .. a-1], a `mod` b == 0]]

ramanujan n = [(a, b, c, d) | a <- [1 .. n], b <- [a + 1 .. n], c <- [1 .. n], d <- [c + 1 .. n], (a^3 + b^3) == (c^3 + d^3), (a, b) < (c, d)]