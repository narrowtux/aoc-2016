defmodule Day10 do
  @day 10
  use Day

  alias Day10.{Robot, Output}

  def part_1 do
    get_input_stream
    |> Stream.map(&parse_instruction/1)
    |> Stream.map(&start_bot/1)
    |> Stream.map(&ensure_all_started/1)
    |> Stream.each(&tell_instruction/1)
    |> Stream.run
  end

  # value 5 goes to bot 189
  @init_instruction ~r/value ([0-9]+) goes to bot ([0-9]+)/

  # bot 109 gives low to output 0 and high to bot 43
  @give_instruction ~r/bot ([0-9]+) gives low to ((output|bot) ([0-9]+)) and high to ((output|bot) ([0-9]+))/ 

  def parse_instruction(instruction) do
    case Regex.run(@init_instruction, instruction) do
      [_, value, bot] ->
        bot = String.to_integer(bot)
        value = String.to_integer(value)
        {bot, {:receive, value}}
      nil ->
        case Regex.run(@give_instruction, instruction) do
          [_, bot, _, low_type, low, _, high_type, high] ->
            bot = String.to_integer(bot)
            low = String.to_integer(low)
            high = String.to_integer(high)
            low_type = String.to_atom(low_type)
            high_type = String.to_atom(high_type)
            {bot, {:give, {low_type, low}, {high_type, high}}}
        end
    end
  end

  def start_bot({bot, instruction}) do
    bot_name = ensure_started({:bot, bot})

    {bot_name, instruction}
  end

  def ensure_all_started({bot, {:give, low, high}}) do
    low = ensure_started(low)
    high = ensure_started(high)
    {bot, {:give, low, high}}
  end

  def ensure_all_started(other), do: other

  def ensure_started({:output, id}) do
    name = :"output_#{id}"
    case GenServer.whereis(name) do
      nil -> Output.start_link(id)
      _ -> :ok
    end
    name
  end

  def ensure_started({:bot, id}) do
    name = :"bot_#{id}"
    case GenServer.whereis(name) do
      nil -> Robot.start_link(id)
      _ -> :ok
    end
    name
  end

  def tell_instruction({bot, instruction}) do
    instruction = case instruction do
      {:receive, _} -> instruction
      {:give, _, _} -> {:instruction, instruction}
    end

    GenServer.cast(bot, instruction)
  end
end