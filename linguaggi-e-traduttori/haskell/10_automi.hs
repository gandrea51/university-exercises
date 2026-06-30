{-
1. Si scriva una funzione Haskell asf che, dati: una sequenza di ingresso [a], uno stato iniziale s, una machine function mfn
   una state function sfn fornisca come risultato una lista di coppie che rappresentano lo stato e l'output dell'automa a
   stati finiti dopo ogni transizione
2. Si disegni un automa a stati finiti con alfabeto di ingresso {0,1} e alfabeto di uscita {oh,no} che fornisce
    ok se la sequenza (che ha valutato fino ad ora) contiene almeno un 1, no altrimenti
    ok se la sequenza (che ha valutato fino ad ora) termina per 1 no altrimenti
    ok se la sequenza (che ha valutato fino ad ora) contiene almeno un fronte di salita (almeno uno 0 seguito da un 1) no altrimenti
-}

asf [] _ _ _ = []
asf (a : as) s mfn sfn = (sfn a s, mfn a s) : asf as (sfn a s) mfn sfn

sfnAlmeno 1 'S' = 'S'
sfnAlmeno 0 s = s
sfnAlmeno 1 'N' = 'S'

mfnAlmeno 1 _ = "ok"
mfnAlmeno 0 'S' = "ok"
mfnAlmeno 0 'N' = "no"

sfnTermina 0 _ = 'N'
sfnTermina 1 _ = 'S'

mfnTermina 0 _ = "no"
mfnTermina 1 _ = "ok"

sfnSalita 1 'A' = 'A'
sfnSalita 1 'B' = 'C'
sfnSalita _ 'C' = 'C'
sfnSalita 0 _ = 'B'

mfnSalita _ 'A' = "no"
mfnSalita 0 'B' = "no"
mfnSalita 1 'B' = "ok"
mfnSalita _ 'C' = "ok"

