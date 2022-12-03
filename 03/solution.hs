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
getSharedItem ((a:as), b) = if a `elem` b then a else getSharedItem (as, b)

getItemPriority :: Char -> Int
getItemPriority item = let ordItem = fromEnum item 
                       in if item >= 'a' then ordItem - lowerCaseOffset else ordItem - upperCaseOffset

getBackpackPriority :: String -> Int
getBackpackPriority backpack = getItemPriority $ getSharedItem $ getCompartments backpack


getGroupPriority :: [String] -> Int
getGroupPriority [a,b,c] = getItemPriority $ getBadge (a, b, c)

getBadge :: (String, String, String) -> Char
getBadge ((a:as), b, c) = if a `elem` b && a `elem` c then a else getBadge (as, b, c)
