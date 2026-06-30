{-
1. Un file di testo poligono.txt contiene le coordinate dei punti che rappresentano i vertici di un poligono; per ogni punto si hanno due 
   coordinate intere: x e y. Nel file, l'ultimo punto coincide con il primo. Scrivere un programma che legge da tastiera le coordinate di un 
   ulteriore punto e comunica all'utente se e' interno o esterno al poligono. Per verificare se un punto P e' interno al poligono:
   si traccia una semiretta a partire dal punto P, si calcola quanti lati del poligono intersecano tale semiretta, se il numero delle 
   intersezioni e' pari, allora il punto e' esterno al poligono, altrimenti (se e' dispari) e' interno
-}

data Point = Point {x :: Float, y :: Float} deriving Show

inters p a b = ((y a > y p) /= (y b > y p)) && (x a + (y p - y a) * (x b - x a) / (y b - y a)) > x p

makePoint row = let [xs, ys] = words row
                in Point (read xs) (read ys)

makeSide ps = zip ps (tail ps)

semir p pol = odd (length [() | (a, b) <- makeSide pol, inters p a b])

main = do inpStr <- readFile "poligono.txt"
          let poligono = map makePoint (lines inpStr)
          putStrLn "Enter the x: "
          xs <- getLine
          putStrLn "Enter the y: "
          ys <- getLine
          let point = Point (read xs) (read ys)
          if semir point poligono then putStrLn "Interior point" else putStrLn "Exterior point"

