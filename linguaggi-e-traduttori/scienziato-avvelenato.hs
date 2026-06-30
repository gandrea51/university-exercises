import Data.List

data Scienziato = Scienziato {cognome :: String, inizio :: Int, fine :: Int, status :: String} deriving (Show, Eq)

parseScienziato :: String -> Scienziato
parseScienziato linea = Scienziato cs (read is) (read fs) st
    where
        [cs, is, fs, st] = words linea

incastro :: Scienziato -> Scienziato -> Bool
incastro s p = not ((fine s < inizio p) || (fine p < inizio s))

main :: IO()
main = do
    inpStr <- readFile "turni.txt"
    let sciens = map parseScienziato (lines inpStr)

    let poss = filter (\x -> status x /= "AVV") sciens      -- Scienziati non avvelenati -> Possibili spie
    let avvels = filter (\x -> status x == "AVV") sciens    -- Scienziati avvelenati
    
    let spies = filter (\x -> all (incastro x) avvels) poss

    let outs = ["Possibili", "spie:"] ++ (map cognome spies) 
    putStrLn (unwords outs)
