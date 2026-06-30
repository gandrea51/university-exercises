{-
1. Scrivere un programma Haskell che legge una stringa da tastiera e la stampa invertita
2. Given a file containing some text, create an output file with everything in reverse
3. Given a file containing some text, create an output file with every word in reverse
4. Un programma Haskell deve controllare le collisioni fra quadrati nel piano. Ogni quadrato e' rappresentato da:
   id, colore, x, y, lato. Il programma deve leggere un file di testo e visualizzare il numero di collisioni che ci sono fra i quadrati,
   ossia il numero di coppie di quadrati che hanno intersezione non nulla
5. Implement the game of nim in Haskell, where the rules of the game are as follows: The board comprises five rows of stars: 
   1: * * * * * - 2: * * * * - 3: * * * - 4: * * - 5: *. Two players take it turn about to remove one or more stars from the end of a single row.
   The winner is the player who removes the last star or stars from the board. Hint: Represent the board as a list of five integers that give the number of stars remaining on 
   each row. For example, the initial board is [5,4,3,2,1].
-}

invertiStr = do putStr "Enter a string: "
                xs <- getLine
                putStrLn ("Reverse is: " ++ reverse xs)
--
invertiEverything = do inpStr <- readFile "input.txt"
                       writeFile "output.txt" (reverse inpStr)
--
invertiEveryword = do inpStr <- readFile "input.txt"
                      let word = words inpStr
                      writeFile "output.txt" (unwords (map reverse word))

--

data Square = Square {id :: Int, colore :: String, x :: Int, y :: Int, lato :: Int} deriving Show

coll q1 q2 = not (x q1 + lato q1 <= x q2 || y q1 + lato q1 <= y q2 || x q2 + lato q2 <= x q1 || y q2 + lato q2 <= y q1)

pair [] = []
pair (x : xs) = [(x, y) | y <- xs] ++ pair xs

specifica qs = length [() | (q1, q2) <- pair qs, coll q1 q2]

makeSquare row = let [id, color, xs, ys, ls] = words row
                 in Square (read id) color (read xs) (read ys) (read ls)

squaring = do inpStr <- readFile "quadrati.txt"
              let sq = map makeSquare (lines inpStr)
              putStrLn ("Collision are: " ++ show (specifica sq))

--

nim = play [5, 4, 3, 2, 1]

play bs = if all (==0) bs then putStrLn "Game end" else do print bs
                                                           putStrLn "Enter the row: "
                                                           row <- readLn
                                                           putStrLn "Enter the stars: "
                                                           star <- readLn
                                                           let ns = change bs row star
                                                           play ns

change (b : bs) 1 s = (b - s) : bs
change (b : bs) r s = b : change bs (r - 1) s

