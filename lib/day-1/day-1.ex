defmodule Narrowtux.Aoc2016.Day1 do
  @day 1
  use Narrowtux.Aoc2016.Day

  def part_1 do
    {:ok, input} = get_input()

    part_1(input)
  end

  def part_1(input) do
    distance = 
      input
      |> String.split(", ")
      |> get_destination({0, 0, :north})
      |> manhattan_distance

    {:ok, distance}
  end

  def part_2(context) do
    
  end

  defp get_destination([], {x, y, _}), do: {x, y}

  defp get_destination([<< turn::binary-size(1), length::binary >> | rest], {x, y, direction}) do
    length = String.to_integer(length)

    new_direction = get_direction(direction, turn)

    IO.puts [Atom.to_string(direction), " -> ", Atom.to_string(new_direction)]

    {dx, dy} = get_vector(new_direction)
    x = x + dx * length
    y = y + dy * length
    get_destination(rest, {x, y, new_direction})
  end

  defp manhattan_distance({x, y}), do: abs(x) + abs(y)

  mdef get_vector do
    :north -> {1, 0}
    :east -> {0, 1}
    :south -> {-1, 0}
    :west -> {0, -1}
  end

  mdef get_direction do
    :north, "R" -> :east
    :north, "L" -> :west
    :east, "R" -> :south
    :east, "L" -> :north
    :south, "R" -> :west
    :south, "L" -> :east
    :west, "R" -> :north
    :west, "L" -> :south
  end
end