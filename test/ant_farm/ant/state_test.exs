defmodule AntFarm.Ant.StateTest do
  use ExUnit.Case
  doctest AntFarm.Ant.State

  alias AntFarm.Ant.State, as: Ant

  describe "ant state" do
    test "move/1 do not changes ant position if speed is zero" do
      initial_position = {0, 0}
      speed = 0

      ant =
        %Ant{position: initial_position, speed: speed}
        |> Ant.move()

      assert ant.position == initial_position
    end

    test "move/1 changes ant position if speed is more than zero" do
      initial_position = {0, 0}
      speed = 1

      ant =
        %Ant{position: initial_position, speed: speed}
        |> Ant.move()

      refute ant.position == initial_position
    end

    test "rotate/2 rotates ant" do
      initial_direction = 45.0
      angle_to_rotate = 90.0
      expected_direction = initial_direction + angle_to_rotate

      ant =
        %Ant{direction: initial_direction}
        |> Ant.rotate(angle_to_rotate)

      assert ant.direction == expected_direction
    end

    test "rotate/2 should limit direction to 360 degrees" do
      initial_direction = 0
      angle_to_rotate = 365
      expected_direction = angle_to_rotate - 360

      ant =
        %Ant{direction: initial_direction}
        |> Ant.rotate(angle_to_rotate)

      assert ant.direction == expected_direction
    end
  end
end
