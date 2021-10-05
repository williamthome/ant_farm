defmodule AntFarm.Colony.Supervisor do
  use DynamicSupervisor

  alias AntFarm.Ant.Boundary, as: AntServer
  alias AntFarm.Ant.Core, as: Ant
  alias AntFarm.Incrementer

  @me __MODULE__

  # Client

  def start_link(_args),
    do: DynamicSupervisor.start_link(@me, :ok, name: @me)

  def add(%Ant{} = ant) do
    spec = {AntServer, ant}

    DynamicSupervisor.start_child(@me, spec)
  end

  def add!(fields),
    do:
      fields
      |> Ant.new!()
      |> add()

  def populate(count \\ 1) do
    for _ <- 1..count, do: add(%Ant{id: Incrementer.increment()})
  end

  def unpopulate do
    for pid <- childrens_pid() do
      @me
      |> DynamicSupervisor.terminate_child(pid)
    end
  end

  def ant_count do
    %{workers: count} = @me |> DynamicSupervisor.count_children()
    count
  end

  def ants,
    do:
      childrens_pid()
      |> Enum.map(&AntServer.get_state(&1))

  defp childrens_pid,
    do:
      @me
      |> DynamicSupervisor.which_children()
      |> Task.async_stream(&get_chilren_pid/1)
      |> Enum.map(fn {:ok, pid} -> pid end)

  defp get_chilren_pid({_id, pid, _type, _modules}), do: pid

  # AntServer

  def init(:ok),
    do: DynamicSupervisor.init(strategy: :one_for_one)
end
