defmodule Day2Test do
  use ExUnit.Case

  @input "ULL
RRDDD
LURDL
UUUUD"

  test "example part 1" do
    assert Day2.part_1(@input) == "1985"
  end

  test "example part 2" do
    assert Day2.part_2(@input) == "5DB3"
  end
end