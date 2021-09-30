defmodule AntFarm.AntTest do
  use ExUnit.Case
  doctest AntFarm.Ant

  alias AntFarm.Ant

  describe "ant" do
    test "start_link/0 starts a new ant process" do
      ant = Ant.start_link()

      assert is_pid(ant)
      assert Process.alive?(ant)
    end

    test "get_state/1 returns ant state" do
      ant = Ant.start_link()
      state = ant |> Ant.get_state()

      assert is_struct(state)
    end
  end
end
