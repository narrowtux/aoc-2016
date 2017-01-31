defmodule Day11 do
  @day 11
  use Day

# The first floor contains a promethium generator and a promethium-compatible microchip.
# The second floor contains a cobalt generator, a curium generator, a ruthenium generator, and a plutonium generator.
# The third floor contains a cobalt-compatible microchip, a curium-compatible microchip, a ruthenium-compatible microchip, and a plutonium-compatible microchip.
# The fourth floor contains nothing relevant.


# The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
# The second floor contains a hydrogen generator.
# The third floor contains a lithium generator.
# The fourth floor contains nothing relevant.

  @input %{
    level: 0,
    levels: [
      [{:gen, :promethium}, {:chip, :promethium}, {:gen, :elerium}, {:chip, :elerium}, {:gen, :dilithium}, {:chip, :dilithium}],
      [{:gen, :cobalt}, {:gen, :curium}, {:gen, :ruthenium}, {:gen, :plutonium}],
      [{:chip, :cobalt}, {:chip, :curium}, {:chip, :ruthenium}, {:chip, :plutonium}],
      []
    ]
  }

  # @input %{
  #   level: 0,
  #   levels: [
  #     [{:chip, :hydrogen}, {:chip, :lithium}],
  #     [{:gen, :hydrogen}],
  #     [{:gen, :lithium}],
  #     []
  #   ]
  # }

  def part_1(), do: part_1(@input)

  def part_1(input) do
    input = sort_input(input)
    goal = sort_input(%{
      level: 3,
      levels: [[], [], [], List.flatten(input.levels)]
    })

    env = {&neighbors/1, &distance/2, &heuristic/2}

    Astar.astar(env, input, goal)
  end

  def neighbors(input) do
    max_layer = length(input.levels) - 1
    layer = input.level
    current_layer = Enum.at(input.levels, layer)
    possible_steps = 
      for dir <- [:up, :down], 
      (dir == :down and layer != 0) or (dir == :up and layer != max_layer),
      length(current_layer) != 0,
      max_items = length(current_layer) - 1,
      item_a <- -1..max_items,
      item_b <- -1..max_items,
      items = Enum.uniq([item_a, item_b]),
      items = Enum.filter(items, &(&1 != -1)),
      [] != items,
      items = Enum.sort(items), do: {dir, layer, items}

    possible_steps
    |> Enum.uniq()
    |> Enum.map(&apply_step(input, &1))
    |> Enum.filter(&is_valid_input?/1)
    |> Enum.map(&sort_input/1)
  end

  def input(), do: @input

  def sort_input(%{levels: levels} = input) do
    levels = Enum.map(levels, &Enum.sort/1)
    Map.put(input, :levels, levels)
  end

  def apply_step(input, {direction, layer, []}) do
    target_layer = case direction do
      :up -> layer + 1
      :down -> layer - 1
    end

    Map.put(input, :level, target_layer)
  end

  def apply_step(input, {direction, layer, [item]}) do
    subject = Enum.at(Enum.at(input.levels, layer), item)

    target_layer = case direction do
      :up -> layer + 1
      :down -> layer - 1
    end

    levels = input.levels
    |> List.update_at(layer, &List.delete_at(&1, item))
    |> List.update_at(target_layer, &Enum.concat(&1, [subject]))

    %{
      levels: levels,
      level: target_layer
    }
  end

  def apply_step(input, {direction, layer, [item_a, item_b]}) do
    subject_a = Enum.at(Enum.at(input.levels, layer), item_a)
    subject_b = Enum.at(Enum.at(input.levels, layer), item_b)

    target_layer = case direction do
      :up -> layer + 1
      :down -> layer - 1
    end

    current_layer_list = Enum.at(input.levels, layer)
    |> Enum.reject(&(&1 in [subject_a, subject_b]))
    target_layer_list = Enum.at(input.levels, target_layer)
    |> Enum.concat([subject_a, subject_b])

    levels = 
      input.levels
      |> List.replace_at(layer, current_layer_list)
      |> List.replace_at(target_layer, target_layer_list)

    %{
      levels: levels,
      level: target_layer
    }
  end
  
  def is_valid_input?(input) do
    Enum.all?(input.levels, &is_valid_layer?/1)
  end

  def is_valid_layer?(layer) do
    layer
    |> Enum.filter(fn 
      {:chip, _} -> true
      {:gen, _} -> false
    end) 
    |> Enum.all?(&is_not_exploding?(layer, &1))
  end

  def is_not_exploding?(layer, {:chip, name}) do
    Enum.member?(layer, {:gen, name}) 
    || !Enum.any?(layer, fn 
      {:gen, _} -> true
      {:chip, _} -> false
    end)
  end

  def distance(a, b) do
    1
  end

  def heuristic(a, b) do
    abs(value(b) - value(a))
  end

  def value(%{levels: levels}), do: value(levels)

  def value([a, b, c, d]) do
    length(a) * 0 + length(b) * 0.125 + length(c) * 0.5 + length(d) * 1
  end
end
