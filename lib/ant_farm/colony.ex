defmodule AntFarm.Colony do
  alias AntFarm.Colony.Supervisor, as: AntColony

  def add(ant),
    do: ant |> AntColony.add()

  def populate(count \\ 1),
    do: count |> AntColony.populate()

  def ant_count,
    do: AntColony.ant_count()

  def ants,
    do: AntColony.ants()
end
