{-# LANGUAGE CPP #-}
#include "../prelude.hs"

f (x:y:xs) = (y-x):f (y:xs)
f _ = []

main = do
  i <- map read . lines <$> readFile "input.txt"
  let s = sort i
  let l = [0] ++ s ++ [last s + 3]
  putStr "Part 1: "
  print $ length (filter (==3) $ f l) * length (filter (== 1) $ f l)
  let g x (y:xs) = if x + 3 < y then 0 else g x xs + (m IMap.! y)
      g x [] = if x == (last s + 3) then 1 else 0
      m = IMap.fromList $ map (\(x:xs) -> (x,g x xs)) $ init $ tails ([0] ++ s ++ [last s + 3])
  putStr "Part 2: "
  print $ m IMap.! 0
