import Data.List

data Ram = Ram {costruttore :: String, tempo :: Int, costo :: Int} deriving (Show, Eq)

parseRAM :: String -> Ram
parseRAM linea = Ram cs (read ts) (read ct)
    where
        [cs, ts, ct] = words linea

dominated :: Ram -> Ram -> Bool
dominated n m = (tempo n <= tempo m) && (costo n <= costo m) && ((tempo n < tempo m) || (costo n < costo m))

main :: IO()
main = do
    inpStr <- readFile "memory.txt"
    let rams = map parseRAM (lines inpStr)  -- [Ram1, Ram2, Ram3, ...]
    
    let mem = [m | m <- rams, not (any (\x -> dominated x m) rams)]     -- [Ram1, Ram2]
    let outs = ["Non", "dominate:"] ++ (map costruttore mem)
    putStrLn (unwords outs)
