import Data.List

data Docente = Docente {cognome :: String, risposte :: [Float]} deriving (Show, Eq)

parseDoc :: String -> Docente
parseDoc linea = let ws = words linea
                 in Docente (head ws) (map read (tail ws))

start :: Docente -> [(Float, String)]
start (Docente cs rs) = [(v,cs) | v <- rs]

graduatoria :: [Docente] -> [[String]]
graduatoria ds = map makeSum (transpose (map start ds))

makeSum :: [(Float, String)] -> [String]
makeSum ts = map snd (reverse (sort ts))

main :: IO()
main = do
    inpstr <- readFile "stat.txt"
    let ds = map parseDoc (lines inpstr)
    let gs = graduatoria ds
    putStrLn (unlines ["Domanda " ++ show i ++ ": " ++ unwords p | (i,p) <- zip [1..] gs])
