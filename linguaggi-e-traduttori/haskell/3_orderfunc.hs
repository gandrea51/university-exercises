import Data.List (sort)
{-
1. Si scriva una funzione che, data una lista di interi, fornisce una lista che contiene True in corrispondenza di ogni valore
   pari e False in corrispondenza dei dispari
2. Si scriva una funzione che, data una lista di interi, fornisce una lista che contiene tutti i valori incrementati di 1
3. Data una lista di elementi, tramite la funzione zip si puo' creare una lista di coppie (elemento,posizione). Si scriva poi una funzione
   trova che fornisce una lista con tutte le posizioni in cui e' presente l'elemento al secondo parametro
-}

verificaPari = map even

incrList = map (+1)

trova xs n = map snd (filter (\(a,_) -> a == n) (zip xs [0..]))

{-
4. Write the function gravity that, given a mass m1, a distance d, and a mass m2, computes the gravitational force
5. Write the function earthGravity that, given a mass and a distance, computes the gravitational force of the Earth on the mass
6. Write a function earthGravitySurface that computes the weight of a mass on the surface of the Earth
7. Function logBase b x computes the logarithm in base b of x. Write function log2 that computes the logarithm in base 2 of a number
-}

gravity m1 d m2 = 6.7e-11 * m1 * m2 / (d**2)

earthGravity = gravity 5.96e24

earthGravitySurface = earthGravity 6.37e6

log2 = logBase 2

{-
Expression                         Type
['a', 'b', 'c']                    [Char]
('a', 'b', 'c')                    (Char, Char, Char)
[(False, '0'), (True, '1')]        [(Bool, Char)]
([False, True], ['0', '1'])        ([Bool], [Char])
[tail, init, reverse]              [[t] -> [t]]
-}

second xs = head (tail xs)         -- [t] -> t 
swap (x,y) = (y,x)                 -- (a,b) -> (b,a)
pair x y = (x,y)                   -- a -> b -> (a, b)
double x = x*2                     -- Num a => a -> a
palindrome xs = reverse xs == xs   -- Eq a => [a] -> Bool
twice f x = f (f x)                -- (t -> t) -> t -> t

{-
8. Count the number of vowels in a string using folds. Useful function: elem x xs checks if x is in list xs
9. Si scriva una funzione seleziona che, data una lista di coppie (nome, listaInteri) fornisce i nomi delle persone in cui listaInteri ha somma > 10
10. Given a list of numbers, create a list of all negated absolute values using map. Useful functions: abs and negate
-}

vowels xs = foldr (\x acc -> if x `elem` "aeiou" then acc + 1 else acc) 0 xs

dati = [("Luigi", [2,5,1,3]), ("Sara", [2,3,8,0]), ("Carla", [2,2,1]), ("Velia", [3,2,1])]

seleziona xs = map fst (filter ((>10).sum.snd) xs)

negateAbs = map (negate.abs)

{-
11. Diana vuole portare alla festa della scuola delle torte. La nonna le ha dato una ricetta; la lista degli ingredienti e' una lista di coppie
    nome, peso. Fortunatamente, Diana ha in casa tutti gli ingredienti; ha una lista con lo stesso formato. Si scriva una funzione Haskell che 
    prende le due liste e visualizza quante torte riuscira' a fare Diana
12. Una lista di coppie rappresenta una sequenza di punti nel piano. Un viaggiatore deve passare per tutti i punti della sequenza. Supponendo che 
    si muova nel piano usando la distanza euclidea (teorema di Pitagora), si calcoli la distanza che deve percorrere. Si implementi la funzione distanza
    usando fold (foldl o foldr a scelta)
-}

ricetta = [("Zucchero", 300), ("Burro", 100), ("Farina", 350)] -- xs
ingredienti = [("Burro", 500), ("Farina", 1000), ("Latte", 1000), ("Zucchero", 700)] -- ys
punti = [(0, 1), (1, 1), (4, 5), (5, 5)]

numTorte xs ys = minimum [y `div` x | (a, y) <- ys, (b, x) <- xs, a == b]

distanza [] = 0
distanza (p : ps) = fst (foldl f (0, p) ps)
 where
   f (tot, (x1, y1)) (x2, y2) = let d = sqrt ((x2 - x1)^2 + (y2 - y1)^2)
                                in (tot + d, (x2, y2))