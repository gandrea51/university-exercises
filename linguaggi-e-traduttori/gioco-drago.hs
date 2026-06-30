import Data.List

data Azione = Azione {compie :: String, subisce :: String, punti :: Int, tipo :: String} deriving (Show, Eq)

parseAction :: String -> Azione 
parseAction linea = Azione cp su (read ps) ts
    where
        [cp, su, ps, ts] = words linea

creaStart :: [Azione] -> [(String, Int)]
creaStart as =  map (\x -> (x, 20)) attori
    where
        fa = map compie as          -- Tutti i personaggi che fanno azioni
        prende = map subisce as     -- Tutti i personaggi che subiscono azioni
        attori = nub (fa ++ prende) -- Tutti i personaggi

islive :: String -> [(String, Int)] -> Bool
islive attore statelist = (snd a) > 0
    where
        a = head (dropWhile (\(x, _) -> x /= attore) statelist)

turno :: [(String, Int)] -> Azione -> [(String, Int)]
turno before (Azione cp su ps _) | islive cp before = esegui su ps before
                                 | otherwise = before

esegui :: String -> Int -> [(String, Int)] -> [(String, Int)]
esegui attore punti statelist = map (\(a, p) -> if (attore == a) then (a, p + punti) else (a, p)) statelist


main :: IO()
main = do
    inpStr <- readFile "combattimento.txt"
    let actions = map parseAction (lines inpStr)    -- [Azione1, Azione2, Azione3, ...]

    let starts = creaStart actions                  -- [(P1, 20), (P2, 20), (P3, 20), ...]
    let ends = foldl turno starts actions
    putStrLn (unlines (map (\(a, p) -> a ++ " " ++ show p) ends))
    