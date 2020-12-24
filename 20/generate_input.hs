import Data.List
import Data.List.Split
import Data.Char

oneSquare n s = "square " ++ n ++ " " ++ intercalate " " (map show s)

showSquare (label:sq) = "(" ++ intercalate " & " (map (oneSquare number) allSquares) ++ ")"
  where number = filter isDigit label
        top = head sq
        bot = last sq
        left = map head sq
        right = map last sq
        rots l = tail $ zipWith (++) (tails l) (inits l)
        cw = rots [top, right, reverse bot, reverse left]
        ccw = rots [left, bot, reverse right, reverse top]
        toBin = foldl' (\n c -> 2 * n + fromEnum (c == '#')) 0
        allSquares = map (\[a,b,c,d] -> map toBin [a,b,reverse c,reverse d]) $ cw ++ ccw

main = do
  squares <- map lines . filter (not . null) . splitOn "\n\n" <$> readFile "input.txt"
  putStrLn "MODULE input."
  putStrLn "input Goal :-"
  putStr   "  ( "
  putStrLn $ intercalate "\n  , " $ map showSquare squares
  putStrLn "  ) -o Goal."
