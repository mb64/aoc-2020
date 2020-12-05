{-# LANGUAGE CPP #-}
#include "../prelude.hs"

seatId = foldl (\n -> \case
    'B' -> 2 * n + 1
    'R' -> 2 * n + 1
    'L' -> 2 * n
    'F' -> 2 * n) 0

main = do
  ids <- map seatId . lines <$> readFile "input.txt"
  putStr "Part 1: "
  print $ maximum ids
  putStr "Part 2: "
  print $ [minimum ids..maximum ids] \\ ids
