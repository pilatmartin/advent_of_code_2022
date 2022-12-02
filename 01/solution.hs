import Data.List.Split
import Data.List

main :: IO()
main = do
  s <- readFile "data.txt"
  print $ "First: " ++ (show $ first s)
  print $ "Second: " ++ (show $ second s)

first :: String -> Int
first s = maximum $ getElves s

second :: String -> Int
second s = sum $ take 3 $ sortBy (flip compare) $ getElves s

getElves :: String -> [Int]
getElves s = map sum $ map (map read) $ splitWhen (=="") $ lines s