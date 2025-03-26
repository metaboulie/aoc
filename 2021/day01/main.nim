# nim r main.nim -d:release ./input.txt
import strutils, sequtils
import std/parseopt

proc numOfIncreased(depths: seq[int]): int =
  zip(depths, depths[1..^1]).countIt(it[0] < it[1])

proc numOfSlidingIncreased(depths: seq[int]): int =
  zip(depths, depths[3..^1]).countIt(it[0] < it[1])

proc main() =
  var path: string
  for kind, key, _ in getopt():
    case kind
    of cmdArgument:
      path = key
    else:
      discard

  let depths = readFile(path).strip().splitLines().map(parseInt)
  echo "Answer to part 1: ", depths.numOfIncreased
  echo "Answer to part 2: ", depths.numOfSlidingIncreased

main()
