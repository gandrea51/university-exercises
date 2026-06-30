import Data.List

data Giocatore = Giocatore {cognome :: String, numeri :: [Int]} deriving (Show, Eq)

parseGio :: String -> Giocatore
parseGio linea = let ws = words linea
                 in Giocatore (head ws) (map read (tail ws))

haVinto :: [Giocatore] -> String
haVinto gs = if (null papabili) then "" else cognome (head papabili)
  where 
    papabili = filter (\x -> null (numeri x)) gs

dropNumber :: Int -> Giocatore -> Giocatore
dropNumber e (Giocatore cs ns) = Giocatore cs (filter (\x -> x /= e) ns)

play :: [Giocatore] -> [Int] -> String
play _ [] = "nessuno"
play gs (e : es) = if (v /= "") then (v) else (play hs es)
  where 
    hs = map (dropNumber e) gs
    v = haVinto hs

main :: IO()
main = do
    inpCart <- readFile "cartelle.txt"
    inpEstr <- readFile "estratti.txt"

    let gs = map parseGio (lines inpCart)
    let ests = map read (words inpEstr)

    putStrLn (unwords ["Vincitore:", play gs ests])

