{-
Analisi Ricors. Disc. Haskell
Una semplice implementazione Haskell dell'analisi ricorsiva discendente. Ogni funzione (associata ad un nonterminale) deve fornire due risultati: 
    un Bool (per dire se la stringa e' stata riconosciuta) - il resto della stringa, su cui deve essere eseguito il parsing
-}
s :: String -> (Bool, String)
s ('p' : t) = x t
s ('q' : t) = y t
s xs = (False, xs)

x ('a' : t) = let (b, r) = x t 
              in (b && head r == 'b', tail r)
x ('x' : t) = (True, t)
x xs = (False, xs)

 