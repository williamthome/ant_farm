defmodule AntFarm.Ant do
  use GenServer

  alias __MODULE__.State, as: Ant

  # Client

  def start_link(id \\ __MODULE__),
    do: GenServer.start_link(__MODULE__, %Ant{id: id}, name: id)

  def get_state(ant_pid),
    do: GenServer.call(ant_pid, :state)

  # Server

  def init(ant),
    do: {:ok, ant}

  def handle_call(:state, _from, ant),
    do: {:reply, ant, ant}
end
