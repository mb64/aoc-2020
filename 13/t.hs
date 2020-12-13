{-# LANGUAGE CPP #-}
#include "../prelude.hs"

f (b,a) (p,m) = (b * p, fromJust $ find (\x -> x `mod` p == (-m) `mod` p) [a,a+b..])

main = do
  [arrival,str] <- lines <$> readFile "input.txt"
  let trains = map read $ filter (/= "x") $ splitOn "," str
  putStr "Part 1: "
  print $ head $ do
    time <- [read arrival..]
    train <- trains
    guard $ time `mod` train == 0
    pure time

  let mods :: [(Int,Int)]
      mods = map (first read) $ filter ((/= "x") . fst) $ zip (splitOn "," str) [0..]
  putStr "Part 2: "
  print $ snd $ foldl1' f mods

