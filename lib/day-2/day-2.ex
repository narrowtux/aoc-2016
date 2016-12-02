defmodule Day2 do
  @day 2
  use Day

  def part_1 do
    {:ok, input} = get_input
    part_1(input)
  end

  def part_2 do
    {:ok, input} = get_input
    part_2(input)
  end

  def part_1(input) do
    part(input, &goto_1/2)
  end

  def part_2(input) do
    part(input, &goto_2/2)
  end

  def part(input, goto_fun) do
    {last, result} = input
    |> String.split("\n")
    |> Enum.reduce({5, ""}, &(decode_all(&1, &2, goto_fun)))

    result
  end

  def decode_all(instructions, {last, result}, goto_fun) do
    next = decode(instructions, last, goto_fun)

    result = "#{result}#{next}"
    {next, result}
  end

  def decode("", current, _), do: current

  def decode(<< instruction::binary-size(1), rest::binary >>, current, goto_fun) do
    next = goto_fun.(instruction, current)
    
    IO.puts "#{current} + #{instruction} -> #{next}"

    decode(rest, next, goto_fun)
  end

# 1 2 3
# 4 5 6
# 7 8 9

  mdef goto_1 do
    "R", 1 -> 2
    "D", 1 -> 4

    "L", 2 -> 1
    "R", 2 -> 3
    "D", 2 -> 5

    "L", 3 -> 2
    "D", 3 -> 6

    "U", 4 -> 1
    "R", 4 -> 5
    "D", 4 -> 7

    "L", 5 -> 4
    "R", 5 -> 6
    "U", 5 -> 2
    "D", 5 -> 8

    "U", 6 -> 3
    "L", 6 -> 5
    "D", 6 -> 9

    "U", 7 -> 4
    "R", 7 -> 8
    
    "U", 8 -> 5
    "L", 8 -> 7
    "R", 8 -> 9

    "U", 9 -> 6
    "L", 9 -> 8

    _, current -> current
  end

#     1
#   2 3 4
# 5 6 7 8 9
#   A B C
#     D

  mdef goto_2 do
    "D", 1 -> 3
    "U", 3 -> 1

    "R", v when v in 2..3 or v in 5..8 -> v + 1
    "L", v when v in 3..4 or v in 6..9 -> v - 1
    "U", v when v in 6..8 -> v - 4
    "D", v when v in 2..4 -> v + 4

    "D", 6 -> "A"
    "D", 7 -> "B"
    "D", 8 -> "C"

    "R", "A" -> "B"
    "R", "B" -> "C"

    "U", "A" -> 6
    "U", "B" -> 7
    "U", "C" -> 8

    "U", "D" -> "B"
    "D", "B" -> "D"

    "L", "B" -> "A"
    "L", "C" -> "B"

    _, current -> current
  end

end