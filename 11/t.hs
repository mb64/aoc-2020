{-# LANGUAGE CPP #-}
#include "../prelude.hs"

input :: IO (HMap.HashMap (Int,Int) Char)
input = do
  i <- HMap.fromList . concatMap (map (\(a,(b,c)) -> ((a,b),c))) . zipWith (map . (,)) [0..] . map (zip [0..]) . lines <$> readFile "input.txt"
  pure i

neighbors i = foldr1 (HMap.unionWith (++)) $ mk <$> [-1..1] <*> [-1..1]
  where mk 0 0 = mempty
        mk x y = let m = HMap.mapWithKey (\k _ -> f m x y k) i in m
        f m x y (a,b) = case HMap.lookup (x+a,y+b) i of
          Nothing -> []
          Just '#' -> [(x+a,y+b)]
          Just 'L' -> [(x+a,y+b)]
          Just '.' -> m HMap.! (x+a,y+b)

step1 s (a,b) v =
  let ps = filter (/= (0,0)) $ (,) <$> [-1..1] <*> [-1..1]
      n = length $ filter (\(x,y) -> (HMap.lookup (a+x,b+y) s) == Just '#') ps
  in case v of
      '#' -> if n >= 4 then 'L' else '#'
      'L' -> if n == 0 then '#' else 'L'
      '.' -> '.'

step nbs s (a,b) v =
  let n = length $ filter (\n -> (s HMap.! n) == '#') $ nbs HMap.! (a,b)
  in case v of
      '#' -> if n >= 5 then 'L' else '#'
      'L' -> if n == 0 then '#' else 'L'
      '.' -> '.'

go1 s = let next = HMap.mapWithKey (step1 s) s in if s == next then s else go1 next
go nbs s = let next = HMap.mapWithKey (step nbs s) s in if s == next then s else go nbs next

main = do
  i <- input
  putStr "Part 1: "
  print $ length $ filter (== '#') $ toList $ go1 i
  let n = neighbors i
  putStr "Part 2: "
  print $ length $ filter (== '#') $ toList $ go n i
