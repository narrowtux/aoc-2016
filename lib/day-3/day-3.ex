defmodule Day3 do
  @day 3
  use Day

  def part_1() do
    part_1(get_input!())
  end

  def part_1(input) when is_binary(input) do
    input
    |> process_input
    |> part_1
  end

  def part_1(list) when is_list(list) do
    list
    |> Enum.count(&valid_triangle?/1)
  end

  def part_2() do
    get_input!()
    |> process_input
    |> Enum.reduce([[], [], []], fn
      [a, b, c], [list_a, list_b, list_c] ->
        [[a | list_a], [b | list_b], [c | list_c]]
    end)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.concat
    |> Enum.chunk(3)
    |> part_1
  end

  def valid_triangle?([a, b, c]) do
    a + b > c 
    and b + c > a
    and c + a > b
  end

  def process_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end