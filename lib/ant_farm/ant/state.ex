defmodule AntFarm.Ant.State do
  @type position :: {float, float}

  @type t :: %__MODULE__{
          id: integer,
          position: position,
          speed: float,
          direction: 0..360
        }

  defstruct id: nil,
            position: {0.0, 0.0},
            speed: 0.0,
            direction: 0

  def move(%__MODULE__{speed: speed, direction: angle, position: {x, y}} = ant) do
    x = Float.round(x + speed * dX(angle), 2)
    y = Float.round(y + speed * dY(angle), 2)

    ant
    |> Map.replace!(:position, {x, y})
  end

  defp dX(angle),
    do: :math.sin(angle * :math.pi() / 180)

  defp dY(angle),
    do: :math.cos(angle * :math.pi() / 180)
end
