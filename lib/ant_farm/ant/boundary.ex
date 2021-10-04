defmodule AntFarm.Ant.Boundary do
  use GenServer

  alias AntFarm.Ant.Core, as: Ant

  @me __MODULE__

  # Client

  def start_link(%Ant{id: id} = ant),
    do: GenServer.start_link(@me, ant, name: name(id))

  defp name(id),
    do: {:via, Registry, {AntFarm.Ant.Registry, id}}

  def get_state(id) when id |> is_pid,
    do: GenServer.call(id, :state)

  def get_state(id),
    do: GenServer.call(name(id), :state)

  def move(id),
    do: GenServer.cast(name(id), :move)

  def rotate(id, angle),
    do: GenServer.cast(name(id), {:rotate, angle})

  # Server

  def init(ant),
    do: {:ok, ant}

  def child_spec(%Ant{id: id} = ant),
    do: %{
      id: name(id),
      start: {@me, :start_link, [ant]}
    }

  def handle_call(:state, _from, ant),
    do: {:reply, ant, ant}

  def handle_cast(:move, ant),
    do: {:noreply, ant |> Ant.move()}

  def handle_cast({:rotate, angle}, ant),
    do: {:noreply, ant |> Ant.rotate(angle)}
end
