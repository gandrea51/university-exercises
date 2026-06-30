{-
1. Fix the syntax errors in the program below, and test your solution using GHCi
2. Consider a function safetail that behaves in the same way as tail, except that safetail maps the empty list to the empty list, whereas tail
   gives an error in this case. Define safetail using: (a) a conditional expression, (b) guarded equations, (c) pattern matching.
   Hint: the library function null::[a] -> Bool can be used to test if a list is empty
3. Give three possible definitions for the logical or operator (||) using pattern matching
4. Redefine (&&) using conditionals rather than patterns
5. Write a Caesar Cipher function called cipher. Suggestion: pred and succ can be used to get the previous and following character
-}

n = a `div` (length xs)
    where
        a = 10
        xs = [1,2,3,4,5]

safetail xs = if null xs then [] else tail xs
safetail2 xs | null xs = []
             | otherwise = tail xs
safetail3 (_ : xs) = tail xs

or1 True True = True
or1 True False = True
or1 False True = True
or1 False False = False
or2 True _ = True
or2 False b = b
or3 a b | a = True
        | otherwise = b

and1 True True = True
and1 True False = False
and1 False True = False
and1 False False = False
and2 False _ = False
and2 True b = b
and3 a b | a = b
         | otherwise = False

cipher xs n = map (`hash` n) xs

hash c 0 = c
hash c n = if n > 0 then hash (succ c) (n - 1) else hash (pred c) (n + 1)

{-
6. Funzione quadlist: data una lista, produce una lista della stessa lunghezza che contiene i quadrati dei valori della lista originaria
7. Funzione acronimo: data una lista di stringhe, fornire la lista che contiene le iniziali di ciascuna delle stringhe
8. Funzione lunghezze: data una lista di liste, produce la lista delle lunghezze
9. Funzione positivi: data una lista di valori numerici, produrre una lista con i soli valori positivi
10. Funzione corte: data una lista di stringhe, fornire la lista delle sole stringhe che hanno meno di 4 caratteri
11. Funzione vocali: data una stringa (lista di Char), tenere solo le vocali minuscole
12. Funzione quadMat: data una lista di liste di numeri, produce una lista di liste con i quadrati degli elementi
13. Funzione esclama: data una lista di stringhe, fornire la lista ottenuta aggiungendo un punto esclamativo in fondo ad ogni stringa
-}

quadList xs = map (**2) xs

acronimo xss = map (head) xss

lunghezze xss = map (length) xss

positivi xs = filter (>= 0) xs

corte xs = filter (\x -> length x < 4) xs

vocali xs = filter (\x -> x `elem` "aeiou") xs

quadMat xss = map quadList xss

esclama xss = map (++['!']) xss

