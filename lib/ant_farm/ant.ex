defmodule AntFarm.Ant do
  use GenServer

  alias __MODULE__.State

  # Client

  def start_link(%State{} = ant \\ %State{}) do
    case GenServer.start_link(__MODULE__, ant, name: __MODULE__) do
      {:ok, ant_pid} -> ant_pid
      error -> error
    end
  end

  def get_state(ant_pid),
    do: GenServer.call(ant_pid, :state)

  # Server

  def init(ant) do
    {:ok, ant}
  end

  def handle_call(:state, _from, ant),
    do: {:reply, ant, ant}
end
