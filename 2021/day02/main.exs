# elixir main.exs ./input.txt
import OptionParser

defmodule Main do
  def main() do
    {_, path, _} = parse(System.argv())

    commands = File.read!(path) |> String.split("\n", trim: true)

    IO.puts("""
    Part 1: #{calculate_position(commands)}
    Part 2: #{calculate_position_with_aim(commands)}
    """)
  end

  defp calculate_position(commands) do
    Enum.reduce(commands, {0, 0}, fn command, {depth, width} ->
      [direction, value] = String.split(command, " ")
      value = String.to_integer(value)

      case direction do
        "forward" -> {depth, width + value}
        "down" -> {depth + value, width}
        "up" -> {depth - value, width}
        _ -> {depth, width}
      end
    end)
    |> then(fn {depth, width} -> depth * width end)
  end

  defp calculate_position_with_aim(commands) do
    Enum.reduce(commands, {0, 0, 0}, fn command, {depth, width, aim} ->
      [direction, value] = String.split(command, " ")
      value = String.to_integer(value)

      case direction do
        "forward" -> {depth + aim * value, width + value, aim}
        "down" -> {depth, width, aim + value}
        "up" -> {depth, width, aim - value}
        _ -> {depth, width, aim}
      end
    end)
    |> then(fn {depth, width, _} -> depth * width end)
  end
end

Main.main()
