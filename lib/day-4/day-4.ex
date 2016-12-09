defmodule Day4 do
  @day 4
  use Day

  @pattern ~r/([a-z\-]+)([0-9]+)\[([a-z]{5})\]/

  alias Experimental.Flow
  
  def part_1() do
    get_input_stream()
    |> Flow.from_enumerable()
    |> Flow.map(&split_input/1)
    |> Flow.map(&order_payload/1)
    |> Flow.map(&checksum/1)
    |> Flow.filter(&is_valid?/1)
    |> Flow.map(&sector_id/1)
    |> Enum.sum
  end

  def part_2() do
    get_input_stream()
    |> Flow.from_enumerable()
    |> Flow.map(&split_input/1)
    |> Flow.filter(&filter_valid_fast_track/1)
    |> Flow.map(&decrypt/1)
    |> Flow.filter(&String.contains?(&1, "north"))
    |> Enum.into([])
  end

  def split_input(string) do
    [_, payload, sector, checksum] = Regex.run(@pattern, string)
    {payload, String.to_integer(sector), checksum}
  end

  def filter_valid_fast_track(input) do
    input
    |> order_payload
    |> checksum
    |> is_valid?
  end

  def order_payload({payload, sector, checksum}) do
    payload = payload
    |> String.replace("-", "")
    |> String.graphemes
    |> Enum.group_by(&(&1))
    |> Map.values
    |> Enum.map(fn [first | _] = list -> {first, length(list)} end)
    |> Enum.sort_by(&(&1), fn
      {l1, s}, {l2, s} -> l1 < l2
      {_, s1}, {_, s2} -> s1 > s2
    end)
    {payload, sector, checksum}
  end
  
  def checksum({payload, sector, checksum}) do
    payload = payload
    |> Enum.take(5)
    |> Enum.map(fn {l, _} -> l end)
    |> :erlang.iolist_to_binary

    {payload, sector, checksum}
  end

  def is_valid?({checksum, _, checksum}), do: true
  def is_valid?(_), do: false

  def sector_id({_, sector, _}), do: sector

  def rot_c(l, 0), do: l
  def rot_c(l, a) when l in ?a..?y, do: rot_c(l + 1, a - 1)
  def rot_c(?z, a), do: rot_c(?a, a - 1)
  def rot_c(?-, _), do: 32 #space

  def rotate_string(string, amount) do
    string
    |> String.to_charlist
    |> Enum.map(&rot_c(&1, amount))
    |> String.Chars.to_string
  end
  
  def decrypt({payload, sector, _}) do
    [rotate_string(payload, sector), "- ", Integer.to_string(sector)]
    |> :erlang.iolist_to_binary
  end
end
