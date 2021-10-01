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

  @position_precision 2

  def move(%__MODULE__{speed: speed, direction: angle, position: {x, y}} = ant) do
    x = Float.round(x + speed * dX(angle), @position_precision)
    y = Float.round(y + speed * dY(angle), @position_precision)

    ant
    |> Map.replace!(:position, {x, y})
  end

  defp dX(angle),
    do: :math.sin(angle * :math.pi() / 180)

  defp dY(angle),
    do: :math.cos(angle * :math.pi() / 180)

  def rotate(%__MODULE__{direction: direction} = ant, angle),
    do: ant |> Map.replace!(:direction, direction + angle)
end
