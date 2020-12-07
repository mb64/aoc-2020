{-# LANGUAGE CPP #-}
#include "../prelude.hs"

main = do
  i <- map lines . splitOn "\n\n" <$> readFile "input.txt"
  putStr "part 1: "
  print $ sum $ map (length . nub . concat) i
  putStr "part 2: "
  print $ sum $ map (length . foldl1 intersect) i
