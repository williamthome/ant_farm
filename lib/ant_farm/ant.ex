defmodule AntFarm.Ant do
  use GenServer

  alias __MODULE__.State, as: Ant

  # Client

  def start_link(id \\ __MODULE__) do
    case GenServer.start_link(__MODULE__, %Ant{id: id}, name: id) do
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
