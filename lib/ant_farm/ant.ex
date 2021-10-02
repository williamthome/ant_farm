defmodule AntFarm.Ant do
  use GenServer

  alias __MODULE__.State, as: Ant

  @me __MODULE__

  # Client

  def start_link(%Ant{id: id} = ant \\ %Ant{id: @me, speed: 1.0}),
    do: GenServer.start_link(@me, ant, name: id)

  def get_state(ant_pid),
    do: GenServer.call(ant_pid, :state)

  def move(ant_pid),
    do: GenServer.cast(ant_pid, :move)

  def rotate(ant_pid, angle),
    do: GenServer.cast(ant_pid, {:rotate, angle})

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

  def handle_cast(:move, ant),
    do: {:noreply, ant |> Ant.move()}

  def handle_cast({:rotate, angle}, ant),
    do: {:noreply, ant |> Ant.rotate(angle)}
end
