defmodule AntFarm.Ant.Colony do
  use DynamicSupervisor

  alias AntFarm.Ant, as: AntServer
  alias AntFarm.Ant.State, as: Ant
  alias AntFarm.Incrementer

  @me __MODULE__

  # Client

  def start_link(_args),
    do: DynamicSupervisor.start_link(@me, :ok, name: @me)

  def start_child(%Ant{} = ant \\ %Ant{id: 0}) do
    spec = {AntServer, ant}

    DynamicSupervisor.start_child(@me, spec)
  end

  def populate(count \\ 1),
    do: for(_ <- 1..count, do: start_child(%Ant{id: Incrementer.increment()}))

  def ants,
    do:
      @me
      |> DynamicSupervisor.which_children()
      |> Task.async_stream(&get_ant_state/1)
      |> filter_successful_tasks()

  defp get_ant_state({_id, ant_pid, _type, _modules}),
    do: ant_pid |> AntServer.get_state()

  defp filter_successful_tasks(tasks),
    do:
      tasks
      |> Enum.filter(fn task ->
        case task do
          {:ok, _result} -> true
          {:exit, _reason} -> false
        end
      end)
      |> Enum.map(fn {:ok, result} -> result end)

  # Server

  def init(:ok),
    do: DynamicSupervisor.init(strategy: :one_for_one)
end
