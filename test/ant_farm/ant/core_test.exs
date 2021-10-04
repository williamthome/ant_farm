defmodule AntFarm.Ant.CoreTest do
  use ExUnit.Case
  doctest AntFarm.Ant.Core

  alias AntFarm.Ant.Core, as: Ant

  describe "ant core" do
    test "move/1 do not changes ant position if speed is zero" do
      initial_position = {0, 0}
      speed = 0

      ant =
        %Ant{id: 0, position: initial_position, speed: speed}
        |> Ant.move()

      assert ant.position == initial_position
    end

    test "move/1 changes ant position if speed is more than zero" do
      initial_position = {0, 0}
      speed = 1

      ant =
        %Ant{id: 0, position: initial_position, speed: speed}
        |> Ant.move()

      refute ant.position == initial_position
    end

    test "rotate/2 rotates ant" do
      initial_direction = 45.0
      angle_to_rotate = 90.0
      expected_direction = initial_direction + angle_to_rotate

      ant =
        %Ant{id: 0, direction: initial_direction}
        |> Ant.rotate(angle_to_rotate)

      assert ant.direction == expected_direction
    end

    test "rotate/2 should limit direction to 360 degrees" do
      initial_direction = 0
      angle_to_rotate = 365
      expected_direction = angle_to_rotate - 360

      ant =
        %Ant{id: 0, direction: initial_direction}
        |> Ant.rotate(angle_to_rotate)

      assert ant.direction == expected_direction
    end
  end
end
