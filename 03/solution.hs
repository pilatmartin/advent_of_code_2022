import Data.List
import Data.List.Split

lowerCaseOffset = 96
upperCaseOffset = 38

main :: IO()
main = do
  s <- readFile "data"
  print $ "First: " ++ (show $ sum $ map getBackpackPriority $ lines s)
  print $ "Second: " ++ (show $ sum $ map getGroupPriority $ chunksOf 3 $ lines s)


getCompartments :: String -> (String, String)
getCompartments backpack = let len = length backpack `div` 2
                           in (take len backpack, drop len backpack)  

getSharedItem :: (String, String) -> Char
getSharedItem (a, b) = (a `intersect` b) !! 0

getItemPriority :: Char -> Int
getItemPriority item = let ordItem = fromEnum item 
                       in if item >= 'a' then ordItem - lowerCaseOffset else ordItem - upperCaseOffset

getBackpackPriority :: String -> Int
getBackpackPriority backpack = getItemPriority $ getSharedItem $ getCompartments backpack


getGroupPriority :: [String] -> Int
getGroupPriority [a,b,c] = getItemPriority $ getBadge (a, b, c)

getBadge :: (String, String, String) -> Char
getBadge (a, b, c) = (a `intersect` b `intersect` c) !! 0
