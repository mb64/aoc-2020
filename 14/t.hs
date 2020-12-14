{-# LANGUAGE CPP #-}
#include "../prelude.hs"

part1 :: (Int,Int) -> [(String,String)] -> [(Int,Int)]
part1 _ (("mask", m):xs) = part1 (foldl' o 0 m, complement $ foldl' z 0 m) xs
  where o n c = n * 2 + fromEnum (c == '1')
        z n c = n * 2 + fromEnum (c == '0')
part1 (o,z) ((a,b):xs) = (addr,value) : part1 (o,z) xs
  where addr = read $ (!! 1) $ splitOn "[" $ init a
        value = (read  b .|. o) .&. z
part1 _ [] = []

part2 :: String -> [(String,String)] -> [(Int,Int)]
part2 _ (("mask", mask):xs) = part2 mask xs
part2 mask ((a,b):xs) = map (\x -> (fromBin x,value)) allAddrs ++ part2 mask xs
  where value = read b
        allAddrs = zipWithM (\m b -> case m of
            'X' -> [True,False]
            '1' -> [True]
            '0' -> [b]) mask
          $ reverse $ take 36 $ toBinRev
          $ read $ filter isDigit a
        toBinRev 0 = repeat False
        toBinRev x = (x `mod` 2 == 1) : toBinRev (x `div` 2)
        fromBin = foldl' (\n bit -> 2 * n + fromEnum bit) 0
part2 _ [] = []

main = do
  i <- map ((\[a,_,b] -> (a,b)) . words) . lines <$> readFile "input.txt"
  putStr "Part 1: "
  print $ sum $ IMap.fromList $ part1 undefined i
  putStr "Part 2: "
  print $ sum $ IMap.fromList $ part2 undefined i
