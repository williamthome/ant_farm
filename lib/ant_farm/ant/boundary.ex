defmodule AntFarm.Ant.Boundary do
  use GenServer

  alias AntFarm.Ant.Core, as: Ant

  @me __MODULE__
  @walking_timeout_range 30..100
  @resting_timeout_range 1_000..2_000

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

  def init(%Ant{action: action} = ant) do
    action |> schedule()

    {:ok, ant}
  end

  def child_spec(%Ant{id: id} = ant),
    do: %{
      id: name(id),
      start: {@me, :start_link, [ant]}
    }

  defp schedule(:walking = action), do: action |> schedule(@walking_timeout_range)
  defp schedule(:resting = action), do: action |> schedule(@resting_timeout_range)

  defp schedule(action, timeout_range),
    do:
      self()
      |> Process.send_after({:perform_action, action}, timeout_range |> Enum.random())

  def handle_info({:perform_action, action}, ant) do
    ant =
      ant
      |> maybe_move?(action)
      |> Map.replace!(:action, action)

    random_action() |> schedule()

    {:noreply, ant}
  end

  defp random_action do
    case Enum.random(0..100) < 98 do
      true -> :walking
      false -> :resting
    end
  end

  defp maybe_move?(%Ant{} = ant, :walking), do: ant |> Ant.move()
  defp maybe_move?(%Ant{} = ant, _action), do: ant

  def handle_call(:state, _from, ant),
    do: {:reply, ant, ant}

  def handle_cast(:move, ant),
    do: {:noreply, ant |> Ant.move()}

  def handle_cast({:rotate, angle}, ant),
    do: {:noreply, ant |> Ant.rotate(angle)}
end
