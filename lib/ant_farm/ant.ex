defmodule AntFarm.Ant do
  use GenServer

  alias __MODULE__.State, as: Ant

  @me __MODULE__

  # Client

  def start_link(id \\ @me),
    do: GenServer.start_link(@me, %Ant{id: id}, name: id)

  def get_state(ant_pid),
    do: GenServer.call(ant_pid, :state)

  # Server

  def init(ant),
    do: {:ok, ant}

  def child_spec(id),
    do: %{
      id: id,
      start: {@me, :start_link, id}
    }

  def handle_call(:state, _from, ant),
    do: {:reply, ant, ant}
end
