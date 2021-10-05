defmodule AntFarm.Ant.Boundary do
  use GenServer

  alias AntFarm.Ant.Core, as: Ant

  @me __MODULE__

  @one_second 1_000
  @fps 30
  @walking_timeout round(@one_second / @fps)
  @resting_timeout_range 1_000..2_000
  @rotate_range 0..360

  # Client

  def start_link(%Ant{} = ant),
    do: GenServer.start_link(@me, ant, name: ant |> name())

  defp name(%Ant{id: id}), do: id |> name()
  defp name(id), do: {:via, Registry, {AntFarm.Ant.Registry, id}}

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

  def child_spec(%Ant{} = ant),
    do: %{
      id: ant |> name(),
      start: {@me, :start_link, [ant]}
    }

  defp schedule(action),
    do:
      self()
      |> Process.send_after({:perform_action, action}, action |> action_timeout())

  defp action_timeout(:walking), do: @walking_timeout
  defp action_timeout(:resting), do: @resting_timeout_range |> Enum.random()
  defp action_timeout(:rotating), do: @resting_timeout_range |> Enum.random()

  def handle_info({:perform_action, action}, ant) do
    ant =
      ant
      |> maybe_move?(action)
      |> maybe_rotate?(action)
      |> Map.replace!(:action, action)

    random_action() |> schedule()

    {:noreply, ant}
  end

  defp random_action do
    case Enum.random(0..100) do
      result when result < 98 -> :walking
      result when result < 99 -> :rotating
      _ -> :resting
    end
  end

  defp maybe_move?(%Ant{} = ant, :walking), do: ant |> Ant.move()
  defp maybe_move?(%Ant{} = ant, _action), do: ant

  defp maybe_rotate?(%Ant{} = ant, :rotating),
    do: ant |> Ant.rotate(@rotate_range |> Enum.random())

  defp maybe_rotate?(%Ant{} = ant, _action), do: ant

  def handle_call(:state, _from, ant),
    do: {:reply, ant, ant}

  def handle_cast(:move, ant),
    do: {:noreply, ant |> Ant.move()}

  def handle_cast({:rotate, angle}, ant),
    do: {:noreply, ant |> Ant.rotate(angle)}
end
