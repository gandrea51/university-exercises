import Data.List

data Esame = Esame {corso :: String, matricola :: Int, giorni :: Int, cognome :: String} deriving (Show, Eq)

parseExam :: String -> Esame
parseExam linea = Esame cs (read ms) (read gs) cg
    where
        [cs, ms, gs, cg] = words linea

average :: [Int] -> Float
average ls = (fromIntegral (sum ls)) / (fromIntegral (length ls))


main :: IO()
main = do
    inpStr <- readFile "corte.txt"
    let esamis = map parseExam (lines inpStr)       -- [Esame1, Esame2, Esame3, ...]
    
    putStrLn (unwords ["Inserisci", "un", "cognome:"])
    inpCognome <- getLine
    let cognomeUtente = inpCognome
    
    putStrLn (unwords ["Giorni trascorsi per lo studente", cognomeUtente])

    let esamiUtente = filter (\x -> cognome x == cognomeUtente) esamis      -- [EsameU1, EsameU2, EsameU3, ...]
    
    let corsiUtente = [corso c | c <- esamiUtente]      -- Corsi che l'utente ha superato
    let giorniUtente = [giorni g | g <- esamiUtente]    -- Giorni impiegati
    let diff = zipWith (-) giorniUtente (0 : giorniUtente)

    putStrLn (unlines [c ++ " " ++ (show d) | (c,d) <- zip corsiUtente diff])

    putStrLn (unwords ["Tabella", "tempi", "superamento", "medi"])
    let corsiTot = nub [corso c | c <- esamis]          -- Tutti i corsi
    putStrLn (unlines [c ++ " " ++ show (average [giorni g | g <- esamis, corso g == c]) | c <- corsiTot])
