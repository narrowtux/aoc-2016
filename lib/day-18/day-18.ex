defmodule Day18 do
  @day 18
  use Day
  alias Experimental.Flow

  @trap "^"
  @safe "."

  def part_1 do
    row = get_input!
    #row = "..^^."

    field = 
    2..400000
    |> Enum.reduce({row, count_safe(row)}, &add_next_row/2)
    |> elem(1)
  end

  def count_safe(input) do
    input 
    |> String.to_char_list
    |> Enum.count(&(&1 == ?.))
  end

  def add_next_row(_, {last_row, count}) do
    next_row = generate_row("", last_row)
    {next_row, count + count_safe(next_row)}
  end

  def generate_row(current, input) do
    index = String.length(current)
    length = String.length(input) - 1
    if index == length + 1 do
      current
    else
      range = :erlang.max(0, index - 1)..:erlang.min(index + 1, length)
      neighbors = String.slice(input, range)
        
      neighbors = case index do
        i when i < length / 2 ->
          String.pad_leading(neighbors, 3, @safe)
        _ ->
          String.pad_trailing(neighbors, 3, @safe)
      end
      
      type = generate_tile(neighbors)
      generate_row(current <> type, input)
    end
  end

  import MultiDef
  mdef generate_tile do
    "^^." -> @trap
    ".^^" -> @trap
    "^.." -> @trap
    "..^" -> @trap
    _     -> @safe
  end
end