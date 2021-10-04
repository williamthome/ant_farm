defmodule AntFarm.Ant.BoundaryTest do
  use ExUnit.Case
  doctest AntFarm.Ant.Boundary

  alias AntFarm.Ant.Boundary, as: AntServer
  alias AntFarm.Ant.Core, as: Ant

  describe "ant boundary" do
    test "start_link/1 starts a new ant process" do
      {:ok, ant} = AntServer.start_link(%Ant{id: 0})

      assert is_pid(ant)
      assert Process.alive?(ant)
    end

    test "get_state/1 returns ant state" do
      {:ok, ant} = AntServer.start_link(%Ant{id: 0})
      state = AntServer.get_state(ant)

      assert is_struct(state)
    end
  end
end
