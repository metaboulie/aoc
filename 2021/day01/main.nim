# nim r main.nim -d:release ./input.txt
import strutils, sequtils
import std/parseopt

proc numOfIncreased(depths: seq[int], step: int): int =
  zip(depths, depths[step..^1]).countIt(it[0] < it[1])

proc main() =
  var path: string
  for kind, key, _ in getopt():
    case kind
    of cmdArgument:
      path = key
    else:
      discard

  let depths = readFile(path).strip().splitLines().map(parseInt)
  echo "Answer to part 1: ", numOfIncreased(depths, 1)
  echo "Answer to part 2: ", numOfIncreased(depths, 3)

main()
