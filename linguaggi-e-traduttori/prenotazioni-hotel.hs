import Data.List

overlap :: Int -> Int -> Prenotazione -> Bool
overlap a p prz = a < partenza prz && p > arrivo prz

ricerca :: Int -> Int -> [Prenotazione] -> String
ricerca a p prs = if (null libere) then "Nessuna disponibilita'" else unwords ["Stanza disponibile:", show (head libere)]
    where
        occupate = [stanza px | px <- prs, overlap a p px]
        libere = [s | s <- [1..20], not (s `elem` occupate)]

libero :: Int -> [Prenotazione] -> Int
libero g prs = 20 - tot
    where
        occupate = [stanza p | p <- prs, g >= arrivo p && g < partenza p]
        tot = length (nub occupate)

luglio :: [Prenotazione] -> [String]
luglio prs = [unwords ["Giorno:", show g, " Libere:", show (libero g prs)], g <- [1..31]]

foot :: IO()
foot = do 
    inpStr <- readFile "miramar.txt"
    let prs = map parsePrenotazione (lines inpStr)
    
    putStrLn ("Inserisci arrivo: ")
    inpA <- getLine 
    let ax = read inpA :: Int
    
    putStrLn ("Inserisci partenza: ")
    inpP <- getLine
    let px = read inpP :: Int
    
    putStrLn (ricerca ax px prs)
    
    putStrLn (unlines (luglio prs))

