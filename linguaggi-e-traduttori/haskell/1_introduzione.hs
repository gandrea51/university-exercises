{-
1. Show how the library function last that selects the last element of a list can be defined using the functions introduced in this lecture
2. Can you think of another possible definition?
3. Similarly, show how the library function init that removes the last element from a list can be defined in two different ways
-}

myLast xs = xs !! (length xs - 1)
myLast2 xs = head (reverse xs)

myInit xs = reverse (tail (reverse xs))
myInit2 [] = []
myInit2 xs = take (length xs - 1) xs

{-
4. Scrivere una funzione isPositive che restituisce True se tutti gli elementi della lista sono positivi
5. Scrivere una funzione elemento che, dati una lista xs e un intero n, fornisce l'elemento n della lista (partendo da 1) (senza usare !!)
6. Scrivere una funzione inverti che, data una lista, fornisce la lista invertita
-}

isPositive [] = True
isPositive xs = if (head xs) >= 0 then isPositive (tail xs) else False

elemento n xs = head (drop (n - 1) xs)

inverti xs = inverti (tail xs) ++ [head xs]

{-
7. Funzione lunghezza: data una lista, ne calcola la lunghezza
8. Funzione concatena: date due liste dello stesso tipo, fornisce la concatenazione delle due liste
9. Funzione concatenaTutte: data una lista di liste, produce la concatenazione delle liste interne
10. Si scriva, usando il pattern-matching, una funzione andlist che, data una lista di Bool, calcola l'and logico degli elementi della lista
-}

lunghezza [] = 0
lunghezza (_ : xs) = 1 + lunghezza xs

concatena xs [] = xs
concatena [] ys = ys
concatena (x : xs) ys = x : concatena xs ys

concatenaTutte [] = []
concatenaTutte (xs : xss) = concatena xs (concatenaTutte xss)

andList [] = True
andList (x : xs) = if x then andList xs else False

{-
11. Scrivere una funzione addVectors che ha come parametri due vettori nel piano e ne calcola la somma
12. Si scriva una funzione zip' che, date due liste, fornisce una lista di coppie. La coppia in posizione i-esima della lista e' costituita da
    l'elemento i-esimo della prima lista e l'elemento i-esimo della seconda lista. Se le due liste hanno lunghezza diversa, zip'
    restituisce una lista con la lunghezza minima delle due
-}

addVectors a b = (fst a + fst b, snd a + snd b)

zip' [] _ = []
zip' _ [] = []
zip' (x : xs) (y : ys) = (x, y) : zip' xs ys 