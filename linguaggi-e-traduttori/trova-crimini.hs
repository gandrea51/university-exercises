import Data.List

data Crimine = Crimine {tipo :: String, nome :: String, civico :: Int} deriving (Show, Eq)
data Indirizzo = Indirizzo {strada :: String, numero :: Int, coordX :: Int, coordY :: Int} deriving (Show, Eq)
type Posizione = (Int, Int)

parseCrime :: String -> Crimine 
parseCrime linea = Crimine ts ns (read cs)
    where
        [ts, ns, cs] = words linea

parseInd :: String -> Indirizzo
parseInd linea = Indirizzo vs (read nm) (read cx) (read cy)
    where 
        [vs, nm, cx, cy] = words linea

trovaCrimini :: [Crimine] -> [Indirizzo] -> [Posizione]
trovaCrimini crims inds = [(coordX ind, coordY ind) | c <- crims, tipo c == "Omicidio", ind <- inds, (nome c == strada ind) && (civico c == numero ind)]

defRiga :: [Posizione] -> Int -> String
defRiga poss y = [if elem (x, y) poss then '*' else ' ' | x <- [0 .. 9]]

main :: IO()
main = do
    inpCrimini <- readFile "crimini.txt"
    inpInd <- readFile "indirizzi.txt"
    let crims = map parseCrime (lines inpCrimini)       -- [Tutti1, Tutti2, Tutti3, ...]
    let indirs = map parseInd (lines inpInd)            -- [Ind1, Ind2, Ind3, ...]
    
    let positions = trovaCrimini crims indirs           -- [(x,y), (x,y), (x,y), ...] dei soli crimini
    let mappa = map (defRiga positions) [0 .. 9]        -- Creo la matrice finale
    putStrLn (unlines (mappa))

    putStrLn (unwords ["Il", "crimine", "successivo", "sara:", "(x=7, y=3)", "quindi", "Bologna 56", "scappate"])

