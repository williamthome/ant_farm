defmodule AntFarm.Ant do
  alias AntFarm.Ant.Boundary, as: Server
  alias AntFarm.Ant.Core, as: Ant

  def create(fields) do
    fields
    |> Ant.new!()
    |> Server.start_link()
  rescue
    ArgumentError -> {:error, {:argument_error, "I think you missed the id field."}}
  end

  def state(ant),
    do: ant |> Server.get_state()

  def move(ant),
    do: ant |> Server.move()

  def rotate(ant, angle),
    do: ant |> Server.rotate(angle)
end
