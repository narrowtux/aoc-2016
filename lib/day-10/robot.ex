defmodule Day10.Robot do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: :"bot_#{id}")
  end

  def init(id) do
    # IO.puts "Bot #{id} - reporting for duty"
    state = %{
      id: id,
      values: [],
      instructions: []
    }
    {:ok, state}
  end

  def handle_cast({:instruction, instruction}, state) do
    instructions = 
      state
      |> Map.get(:instructions)
      |> Enum.concat([instruction])

    state = 
      state
      |> Map.put(:instructions, instructions)
      |> trigger
    
    {:noreply, state}
  end

  def handle_cast({:receive, value}, state) do
    # IO.puts "Bot #{state[:id]} - Got value #{value}"
    values = 
      state
      |> Map.get(:values)
      |> Enum.concat([value])
      |> Enum.sort

    state = 
      state
      |> Map.put(:values, values)
      |> trigger()

    {:noreply, state}
  end

  def handle_cast({:give, low_pid, high_pid}, state) do
    [low, high] = state[:values]
    # IO.puts "Bot #{state[:id]} - Sending low (#{low}) to #{inspect low_pid}"
    # IO.puts "Bot #{state[:id]} - Sending high (#{high}) to #{inspect high_pid}"
    GenServer.cast(low_pid, {:receive, low})
    GenServer.cast(high_pid, {:receive, high})
    state = %{state | values: []}
    {:noreply, state}
  end

  defp trigger(state) do
    case state[:values] do
      [17, 61] -> 
        IO.puts [IO.ANSI.green, "bot ", Integer.to_string(state[:id]), IO.ANSI.reset]
      _ -> :ok
    end
    case state do
      %{values: v, instructions: [instruction | rest]} when length(v) == 2 ->
        GenServer.cast(self, instruction)
        %{state | instructions: rest}
      _ -> state
    end
  end
end