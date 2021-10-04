defmodule AntFarm.AntTest do
  use ExUnit.Case
  doctest AntFarm.Ant

  alias AntFarm.Ant, as: AntServer
  alias AntFarm.Ant.State, as: Ant

  describe "ant" do
    test "start_link/0 starts a new ant process" do
      {:ok, ant} = AntServer.start_link(%Ant{id: 0})

      assert is_pid(ant)
      assert Process.alive?(ant)
    end

    test "get_state/1 returns ant state" do
      id = 0

      AntServer.start_link(%Ant{id: id})
      state = AntServer.get_state(id)

      assert is_struct(state)
    end
  end
end
