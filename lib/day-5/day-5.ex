defmodule Day5 do
  @day 5
  use Day
  alias Experimental.Flow

  def part_1 do
    get_input!
    |> part_1
  end

  def part_1(input) do
    input
    |> get_hashes()
    |> Enum.take(8)
    |> Enum.map(fn
      << "00000"::binary, letter::size(1)-binary, _::binary >> -> letter
      _ -> nil
    end)
    |> :erlang.iolist_to_binary
  end

  def part_2() do
    get_input!
    |> part_2()
  end
  
  def part_2(input) do
    acc = 
      Stream.repeatedly(fn()-> " " end)
      |> Enum.take(8)

    input
    |> get_hashes()
    |> Enum.reduce_while(acc, fn
      << "00000"::binary, pos::size(1)-binary, letter::size(1)-binary, _::binary >>, acc when pos in ["0", "1", "2", "3", "4", "5", "6", "7"] ->
        pos = String.to_integer(pos) 
        acc = case Enum.at(acc, pos) do
          nil -> acc
          " " -> List.replace_at(acc, pos, letter)
          _ -> acc
        end
        if Enum.any?(acc, &(&1 == " ")) do
          {:cont, acc}
        else
          {:halt, acc}
        end
      _, acc -> {:cont, acc}
    end)
    |> :erlang.iolist_to_binary
  end

  def get_hashes(input) do
    Stream.iterate(0, &(&1 + 1))
    |> Flow.from_enumerable
    |> Flow.map(&([input, Integer.to_string(&1)]))
    |> Flow.map(&:crypto.hash(:md5, &1))
    |> Flow.map(&Base.encode16(&1, case: :lower))
    |> Flow.filter(fn 
      << "00000"::binary, rest::binary >> -> 
        IO.puts ["Found ", rest]
        true
      _ -> false
    end)
  end
end