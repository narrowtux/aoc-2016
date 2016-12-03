defmodule Day do
  @callback day() :: number
  @callback part_1() :: {:ok, term}
  @callback part_2(context :: term) :: {:ok, term}

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
      import unquote(__MODULE__)
      import MultiDef

      def day() do
        @day
      end

      def get_input_file() do
        "lib/day-#{day}/input.txt"
      end

      def get_input_stream() do
        get_input_file()
        |> File.stream!()
      end

      def get_input() do
        get_input_file()
        |> File.read()
      end

      def get_input!() do
        {:ok, input} = get_input()
        input
      end

      defoverridable(day: 0, get_input: 0, get_input_stream: 0, get_input_file: 0)
    end
  end
end
