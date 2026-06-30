import Data.List (sort)
{-
1. Define a function tenSmallest that provides the 10 smallest elements of a list
2. Define a function ifPzn that evaluates to pos if x>0, zero if x=0, neg if x<0, then write a function solve that provides 
   a list of the solutions of the equation ax^2 + bx + c = 0
3. Scrivere una funzione merge che, date due liste ordinate (anche infinite) fornisce la lista ordinata (eventualmente infinita) che contiene 
   gli elementi di entrambe le liste
4. A well-known problem, due to the mathematician W.R. Hamming, is to write a program that produces an infinite list of numbers with the following properties:
   the list is in strictly increasing order; the list begins with the number 1; if the list contains the number x, then it also contains the numbers 2x, 3x and 5x; 
   the list contains no other numbers. Thus, the required list begins with the numbers 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ... Write a definition of hamming that 
   produces this list. Suggestion: Write a function merge that merges two sorted lists into a sorted list
5. The Kleene closure of a set S is the set of all strings with S as the alphabet. It's usually written as S*. For example, the Kleene closure of S={0,1} is given on
   the left. Write a function kleene that generates the Kleene closure of the set [a]
6. Il crivello di Eratostene serve a calcolare la sequenza dei numeri primi, partendo dalla sequenza di tutti i numeri >=2. Si parte da 2: riportiamo il 2 nella lista di uscita ed
   eliminiamo dalla lista di ingresso tutti i multipli di 2. Riportiamo in uscita il primo numero rimasto (che a questo punto e' il 3) e togliamo tutti i suoi multipli.
   Riportiamo il primo numero rimasto (5) e togliamo tutti i suoi multipli
7. You want to produce an infinite list of all distinct pairs (x, y) of natural numbers. It doesn't matter in which order the pairs are enumerated, as long as they all are there. Say
   whether or not the definition allPairs= [(x,y)| x<-[0..], y<-[0..]] does the job. If you think it doesn't, can you give a version that does? Suggerimento: in quale posizione della lista e'
   l'elemento (2,1)?
8. Il metodo d'Hondt ripartisce S seggi proporzionalmente ai voti. Per ogni partito i, si calcolano i quozienti Qi,j=votii /j con j=1,2,3,... Si raccolgono tutti i quozienti in un'unica tabella
   Gli S seggi sono assegnati ai partiti che possiedono gli S valori piu' alti nell'intera tabella. Es: 8 seggi devono essere suddivisi fra 4 partiti, chiamati A, B, C e D, che hanno ricevuto
   i seguenti voti: A:100000, B:80000, C:30000, D:20000
   Partito /1 /2 /3 /4 /5 ...
   A 100000 50000 33333 25000 20000 ...
   B 80000 40000 26666 20000 16000 ...
   C 30000 15000 10000 7500 6000 ...
   D 20000 10000 6666 5000 4000 ...
   Scrivere una funzione seggi che, dati un numero di seggi e una lista di voti crea una lista con il numero di seggi assegnato a ciascun partito
-}

tenSmallest :: Ord a => [a] -> [a]
tenSmallest = (take 10) . sort

ifPzn x pos zero neg = if x > 0 then pos else (if x == 0 then zero else neg)

solve a b c = ifPzn d [(-b - rd) / (2 * a), (-b + rd) / (2 * a)] [(-b) / (2 * a)] []
 where
    d = b^2 - 4*a*c
    rd = sqrt d

merge xs [] = xs
merge [] ys = ys
merge (x : xs) (y : ys) = if x <= y then x : merge xs (y : ys) else y : merge (x : xs) ys

mergeRD xs [] = xs
mergeRD [] ys = ys
mergeRD (x : xs) (y : ys) = if x < y then x : mergeRD xs (y : ys) else (if x == y then y : mergeRD xs ys else y : mergeRD (x : xs) ys)

hamming = 1 : mergeRD (map (*2) hamming) (mergeRD (map (*3) hamming) (map (*5) hamming))

kleene xs = [] : [x : y | y <- kleene xs, x <- xs]

crivello (x : xs) =  x : crivello [a | a <- xs, a `mod` x /= 0]

allPairs = [(x, y) | d <- [0 ..], x <- [0 .. d], let y = d - x]

seggi n voti = partiti
   where
      quozienti = [(v `div` j, i + 1) | (i, v) <- zip [0 ..] voti, j <- [1 .. n]]
      vinti = take n (reverse (sort quozienti))
      partiti = map (snd) vinti
