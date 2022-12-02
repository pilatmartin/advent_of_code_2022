import Data.List
import Data.Maybe

moves = ["A", "B", "C"]
winStep = 1 -- A wins to B, B wins to C, ...
loseStep = 2 -- A loses to C, B loses to A, ...
winPoints = 6
drawPoints = 3

main :: IO()
main = do
  s <- readFile "data"
  print $ "First: " ++ (show $ eval evalMatch $ lines s)
  print $ "Second: " ++ (show $ eval evalDecryptedMatch $ lines s)

eval :: ([String] -> Int) -> [String] -> Int
eval evalFn matches = sum $ map evalFn $ map words matches

evalMatch :: [String] -> Int  
evalMatch ["C","X"] = winPoints + 1
evalMatch ["A","Y"] = winPoints + 2
evalMatch ["B","Z"] = winPoints + 3
evalMatch [a,b] 
    | a == convert b = drawPoints + (getValue $ convert b)
    | otherwise = getValue $ convert b

evalDecryptedMatch :: [String] -> Int
evalDecryptedMatch [a,"X"] = getValue $ getNextMove loseStep a
evalDecryptedMatch [a,"Y"] = drawPoints + (getValue a)
evalDecryptedMatch [a,"Z"] = winPoints + (getValue $ getNextMove winStep a)

getNextMove :: Int -> String -> String
getNextMove step move = (!!) moves $ (fromJust (elemIndex move moves) + step) `mod` 3

getValue :: String -> Int
getValue a = 1 + (fromJust $ elemIndex a moves)

convert :: String -> String
convert a = [toEnum $ fromEnum (a !! 0) - 23]
