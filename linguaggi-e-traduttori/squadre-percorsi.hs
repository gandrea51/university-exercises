import Data.List

data Piano = Piano {colore :: String, coordX :: Int, coordY :: Int} deriving (Show, Eq)

parsePiano :: String -> Piano
parsePiano linea = Piano cs (read cx) (read cy)
    where
        [cs, cx, cy] = words linea

makePairs :: Piano -> (Int, Int)
makePairs (Piano _ x y) = (x, y)

distanza :: (Int, Int) -> (Int, Int) -> Int
distanza (x1, y1) (x2, y2) = abs (x2 - x1) + abs (y2 - y1)

stradaPercorsa :: [Piano] -> Int
stradaPercorsa ps = sum (zipWith distanza primo secondo)
    where
        punti = map makePairs ps
        primo = (0, 0) : punti
        secondo = punti

percorsi :: [Piano] -> [(String, Int)]
percorsi ps =  map (\c -> (c, stradaPercorsa (filter (\y -> colore y == c) ps))) colori
    where
        colori = nub (map colore ps)

stacanov :: [(String, Int)] -> (String, Int)
stacanov [x] = x
stacanov ((c, k) : ds) = if (k > mK) then (c, k) else (mC, mK)
    where
        (mC, mK) = stacanov ds 

main :: IO()
main = do
    inpStr <- readFile "idranti.txt"
    let ps = map parsePiano (lines inpStr)

    let risultato = percorsi ps
    let (c,k) = stacanov risultato
    putStrLn (unwords ["The winner is:", c, "with km:", show k])


