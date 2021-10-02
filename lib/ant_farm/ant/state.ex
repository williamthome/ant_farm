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
    position = {
      x |> axis_direction(speed, angle, :x),
      y |> axis_direction(speed, angle, :y)
    }

    ant
    |> Map.replace!(:position, position)
  end

  defp axis_direction(current_direction, speed, angle, axis),
    do:
      current_direction
      |> Kernel.+(speed * ratio(angle, axis))
      |> Float.round(@position_precision)

  defp ratio(angle, :x), do: :math.sin(angle |> to_rad)
  defp ratio(angle, :y), do: :math.cos(angle |> to_rad)
  defp to_rad(angle), do: angle * :math.pi() / 180

  def rotate(%__MODULE__{direction: direction} = ant, angle),
    do: ant |> Map.replace!(:direction, direction + angle)
end
