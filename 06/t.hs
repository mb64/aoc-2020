{-# LANGUAGE CPP #-}
#include "../prelude.hs"

main = do
  i <- filter (not . null) . groupBy ((==) `on` null) . lines <$> readFile "input.txt"
  putStr "part 1: "
  print $ sum $ map (length . nub . concat) i
  putStr "part 2: "
  print $ sum $ map (length . foldl1 Set.intersection . map Set.fromList) i
