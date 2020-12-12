import Data.Complex
import Data.List

part1 (s,h) ('L':n) = (s,h*exp(0 :+ read n/180*pi))
part1 (s,h) ('R':n) = (s,h/exp(0 :+ read n/180*pi))
part1 (s,h) ('N':n) = (s+(0 :+ read n),h)
part1 (s,h) ('S':n) = (s-(0 :+ read n),h)
part1 (s,h) ('E':n) = (s+(read n :+ 0),h)
part1 (s,h) ('W':n) = (s-(read n :+ 0),h)
part1 (s,h) ('F':n) = (s+(read n :+ 0)*h,h)

part2 (s,w) ('L':n) = (s,w*exp(0 :+ read n*pi/180))
part2 (s,w) ('R':n) = (s,w/exp(0 :+ read n*pi/180))
part2 (s,w) ('N':n) = (s,w+(0 :+ read n))
part2 (s,w) ('S':n) = (s,w-(0 :+ read n))
part2 (s,w) ('E':n) = (s,w+(read n :+ 0))
part2 (s,w) ('W':n) = (s,w-(read n :+ 0))
part2 (s,w) ('F':n) = (s+(read n :+ 0)*w,w)

main = do
  i <- lines <$> readFile "input.txt"
  putStr "Part 1: "
  print $ let (x :+ y,_) = foldl' part1 (0, 1) i
          in abs x + abs y
  putStr "Part 2: "
  print $ let (x :+ y,_) = foldl' part2 (0, 10 :+ 1) i
          in abs x + abs y
