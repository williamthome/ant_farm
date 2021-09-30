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
  end
end
