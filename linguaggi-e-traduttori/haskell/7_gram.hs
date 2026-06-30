{-
1. 
2. Si scriva un programma Haskell che, data una grammatica di tipo 2 fornita come lista di regole Regola Char String 
   fornisce una lista di Char che contiene i nonterminali che possono (anche in piu' passaggi) riscriversi nella lista vuota
-}

data Regola = Regola Char String
-- [Regola 'A' "aBa", Regola 'B' "CD", Regola 'D' "Ca", Regola 'C' "k"]

nonTerm c = c `elem` ['A' .. 'Z']

find (Regola c esp : rs) a = if c == a then esp else find rs a

scomponi regole (x : xs) = if nonTerm x then find regole x ++ xs else x : scomponi regole xs

deriva regole s = if all (not.nonTerm) s then s else deriva regole (scomponi regole s)

--

setNull regole = trova uno
    where
        uno = [a | Regola a "" <- regole]
        trova ns = let new = [x | Regola x esp <- regole, all (\c -> nonTerm c && c `elem` ns) esp, not (x `elem` ns)]
                       bis = ns ++ nuovi
                   in if null new then ns else trova bis


