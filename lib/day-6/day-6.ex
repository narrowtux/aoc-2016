defmodule Day6 do
  @day 6
  use Day
  
  def part_1() do
    get_input_stream()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.into([])
    |> List.zip()
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&Enum.sort/1)
    |> Stream.map(fn list -> Enum.reduce(list, [], &find_amounts/2) end)
    |> Stream.map(&Enum.sort(&1, fn {_, a}, {_, b} -> a < b end))
    |> Stream.map(&Enum.take(&1, 1))
    |> Stream.map(fn [{l, _}] -> l end)
    |> Enum.into([])
    |> IO.puts
  end

  def find_amounts(letter, [{letter, num} | rest_acc]) do
    [{letter, num + 1} | rest_acc]
  end

  def find_amounts(letter, rest_acc) do
    [{letter, 1} | rest_acc]
  end
end