{-# LANGUAGE CPP #-}
#include "../prelude.hs"

process (a:b:c:d)
    | Just x <- readMaybe a = (x::Int, unwords [b, c]) : process d
    | otherwise = process $ b:c:d
process _ = []

main = do
  i <- map (\(a:b:x) -> (unwords [a,b], process (drop 2 x))) . map words . lines <$> readFile "input.txt"
  let b = map (second (map snd)) i
  let dfs x = let l = fromJust $ lookup x b in l ++ concatMap dfs l
  putStr "Part 1: "
  print $ length $ filter (\x -> "shiny gold"`elem`dfs x) $ map fst b
  let r x = sum $ map (\(n,y) -> n * (1 + r y)) $ fromJust $ lookup x i
  putStr "Part 2: "
  print $ r "shiny gold"

