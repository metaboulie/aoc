# julia main.jl ./input.txt
function is_winner(board)
  return any(sum(board, dims=1) .== -5) || any(sum(board, dims=2) .== -5)
end
function partone(boards, numbers)
  winner = similar(boards[1])
  winner_number = 0
  for number = numbers
    replace!.(boards, number => -1)
    idx = findfirst(is_winner, boards)
    if idx !== nothing
      winner = boards[idx]
      winner_number = number
      break
    end
  end
  sum(filter(x -> x != -1, vec(winner))) * winner_number
end
function parttwo(boards, numbers)
  winner = similar(boards[1])
  winner_number = 0
  for number in numbers
    replace!.(boards, number => -1)
    while !isempty(boards)
      idx = findfirst(is_winner, boards)
      if idx === nothing
        break
      end
      winner = boards[idx]
      winner_number = number
      deleteat!(boards, idx)
    end
  end
  sum(filter(x -> x != -1, vec(winner))) * winner_number
end
function main(args)
  sections = split(read(open(args[1]), String), "\n\n")
  numbers = parse.(Int, split(popfirst!(sections), ","))
  boards = Matrix{Int}[]
  for idx in eachindex(sections)
    push!(boards, stack(map(x -> parse.(Int, x), filter!.(!isempty, split.(split(sections[idx], "\n", keepempty=false), " "))), dims=1))
  end
  println(partone(copy(boards), numbers))
  println(parttwo(copy(boards), numbers))
end
main(ARGS)
