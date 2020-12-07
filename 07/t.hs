{-# LANGUAGE CPP #-}
#include "../prelude.hs"

process (a:b:c:d)
    | Just x <- readMaybe a = (x::Int, unwords [b, c]) : process d
    | otherwise = process $ b:c:d
process _ = []

main = do
  i <- map (\(a:b:x) -> (unwords [a,b], process (drop 2 x))) . map words . lines <$> readFile "input.txt"
  let m1 = Map.fromListWith S.union $ i >>= \(x,l) -> l <&> \(_,y) -> (y,S.insert x $ fromMaybe mempty $ M.lookup x m1)
  putStr "Part 1: "
  print $ length $ m1 M.! "shiny gold"
  let m2 = Map.fromList $ i <&> \(x,l) -> (x,sum $ map (\(n,y) -> n * (1 + m2 M.! y)) l)
  putStr "Part 2: "
  print $ m2 M.! "shiny gold"

