defmodule AntFarm.Ant.StateTest do
  use ExUnit.Case
  doctest AntFarm.Ant.State

  alias AntFarm.Ant.State, as: Ant

  describe "ant state" do
    test "move/1 do not changes ant position if speed is zero" do
      before_move = %Ant{speed: 0}
      after_move = before_move |> Ant.move()

      assert before_move.position == after_move.position
    end

    test "move/1 changes ant position if speed is more than zero" do
      before_move = %Ant{speed: 1}
      after_move = before_move |> Ant.move()

      assert before_move.position != after_move.position
    end

    test "rotate/2 rotates ant" do
      ant =
        %Ant{direction: 45.0}
        |> Ant.rotate(90.0)

      assert ant.direction == 135.0
    end
  end
end
