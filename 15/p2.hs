{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE LinearTypes #-}
{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DeriveGeneric #-}

import Prelude.Linear (Consumable(..), Ur(..), (&))
import qualified Data.HashMap.Mutable.Linear as HMap
import Data.Hashable
import qualified Data.Eq.Linear as Linear
import GHC.Generics

-- Word around `hash = id` for `Int`s
newtype I = I Int deriving (Linear.Eq,Eq,Ord,Show,Num,Enum,Real,Integral,Generic)

instance Hashable I where
  hash (I x) = x `hashWithSalt` (12345 :: Int)

go :: HMap.HashMap I I %1-> I -> I -> Ur I
go !m !n 30_000_000 = consume m & \case () -> Ur n
go !m !n !t = next (HMap.alterF (\old -> (Ur old,Ur (Just t))) n m)
  where next :: (Ur (Maybe I), HMap.HashMap I I) %1-> Ur I
        next (Ur (Just t'),m') = go m' (t - t') (t+1)
        next (Ur Nothing,  m') = go m' 0 (t+1)

part2 :: [I] -> I
part2 inp = res
  where starting = zip (init inp) [1..]
        Ur res = HMap.fromList starting \m -> go m (last inp) (I $ length inp)

input :: [I]
input = [1,20,8,12,0,14]

main = do
  putStr "Part 2: "
  print $ part2 input
