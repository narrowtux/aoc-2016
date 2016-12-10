defmodule Day10.Output do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: :"output_#{id}")
  end
  
  def init(id) do
    # IO.puts "Output #{id} - ready"
    {:ok, %{id: id, values: []}}
  end
  
  def handle_cast({:receive, value}, state) do
    values = 
      state[:values]
      |> Enum.concat([value])
    
    IO.puts "Output #{state[:id]} - #{inspect values, char_lists: false}"

    {:noreply, %{state | values: values}}
  end
end