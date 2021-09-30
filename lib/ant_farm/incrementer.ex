defmodule AntFarm.Incrementer do
  use GenServer

  @me __MODULE__

  # Client

  def start_link(initial_value \\ 0) when initial_value |> is_integer,
    do: GenServer.start_link(@me, initial_value, name: @me)

  def current_value(),
    do: GenServer.call(@me, :current_value)

  def increment(amount \\ 1),
    do: GenServer.call(@me, {:increment, amount})

  # Server

  def init(initial_value),
    do: {:ok, initial_value}

  def child_spec(initial_value),
    do: %{
      id: @me,
      start: {@me, :start_link, initial_value}
    }

  def handle_call(:current_value, _from, current_value),
    do: {:reply, current_value, current_value}

  def handle_call({:increment, amount}, _from, current_value) do
    incremented = current_value + amount
    {:reply, incremented, incremented}
  end
end
