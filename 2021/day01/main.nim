import strutils, sequtils

proc numOfIncreased(depths: seq[int]): int =
  zip(depths, depths[1..^1]).countIt(it[0] < it[1])

proc numOfSlidingIncreased(depths: seq[int]): int =
  zip(depths, depths[3..^1]).countIt(it[0] < it[1])

proc main(filePath: string) =
  let depths = readFile(filePath).strip().splitLines().map(parseInt)
  echo "Answer to part 1: ", depths.numOfIncreased
  echo "Answer to part 2: ", depths.numOfSlidingIncreased

main("./input.txt")
