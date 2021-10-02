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

  # Server

  def init(:ok),
    do: DynamicSupervisor.init(strategy: :one_for_one)
end
