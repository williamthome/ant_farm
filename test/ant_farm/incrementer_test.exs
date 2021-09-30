defmodule AntFarm.IncrementerTest do
  use ExUnit.Case
  doctest AntFarm.Incrementer

  alias AntFarm.Incrementer

  describe "incrementer" do
    test "increment/0 increments one" do
      current_value = Incrementer.current_value()
      incremented = Incrementer.increment(1)

      assert incremented == current_value + 1
    end
  end
end
