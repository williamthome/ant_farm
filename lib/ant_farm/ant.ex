defmodule AntFarm.Ant do
  use GenServer

  alias __MODULE__.State

  # Client

  def start_link(%State{} = state \\ %State{}) do
    case GenServer.start_link(__MODULE__, state, name: __MODULE__) do
      {:ok, ant} -> ant
      error -> error
    end
  end

  def get_state(ant),
    do: GenServer.call(ant, :state)

  # Server

  def init(state) do
    {:ok, state}
  end

  def handle_call(:state, _from, state),
    do: {:reply, state, state}
end
