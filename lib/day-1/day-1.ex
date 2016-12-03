defmodule Day1 do
  @day 1
  use Day

  @ets_name :visited_locations
  @ets :ets.new(@ets_name, [:set])

  def part_1 do
    {:ok, input} = get_input()
    
    # :ets.new(@ets_name, [:set])

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

  defp get_destination([], {x, y, _}), do: {x, y}

  defp get_destination([<< turn::binary-size(1), length::binary >> | rest], {x, y, direction}) do
    length = String.to_integer(length)


    new_direction = get_direction(direction, turn)

    old = {x, y}

    {dx, dy} = get_vector(new_direction)
    x = x + dx * length
    y = y + dy * length

    walk(old, {x, y})
    |> Enum.slice(1, 100_000)
    |> Enum.each(&check_ets/1)

    get_destination(rest, {x, y, new_direction})
  end

  def walk({from_x, y}, {to_x, y}) do
    for x <- from_x..to_x do
      {x, y}
    end
  end

  def walk({x, from_y}, {x, to_y}) do
    for y <- from_y..to_y do
      {x, y}
    end
  end

  def check_ets({x, y}) do
    case :ets.member(@ets, {x, y}) do
      true -> IO.puts "Visited #{x}, #{y} for the second time"
      false -> :ets.insert(@ets, {{x, y}, true})
    end
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