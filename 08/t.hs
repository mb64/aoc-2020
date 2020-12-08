{-# LANGUAGE CPP #-}
#include "../prelude.hs"
import System.IO.Unsafe

i = unsafePerformIO $ map (\s -> let [a,b] = words s in (a,if head b == '-' then read b :: Int else read (tail b))) . lines <$> readFile "input.txt"
m = IMap.fromList $ zip [0..] i

f pc acc s | pc `ISet.member` s = Nothing
f pc acc s = case IMap.lookup pc m of
  Nothing -> Nothing
  Just ("nop",i) -> g (pc+i) acc (ISet.insert pc s) <|> f (pc+1) acc (ISet.insert pc s)
  Just ("jmp",i) -> g (pc+1) acc (ISet.insert pc s) <|> f (pc+i) acc (ISet.insert pc s)
  Just ("acc",n) -> f (pc+1) (acc+n) (ISet.insert pc s)
g pc acc s | pc `ISet.member` s = Nothing
g pc acc s | pc == length i = Just acc
g pc acc s = case IMap.lookup pc m of
  Nothing -> Nothing
  Just ("nop",_) -> g (pc+1) acc (ISet.insert pc s)
  Just ("jmp",i) -> g (pc+i) acc (ISet.insert pc s)
  Just ("acc",n) -> g (pc+1) (acc+n) (ISet.insert pc s)

main = print $ f 0 0 mempty
