defmodule AntFarm.Ant do
  use GenServer

  alias __MODULE__.State

  def start_link(%State{} = state \\ %State{}) do
    case GenServer.start_link(__MODULE__, state, name: __MODULE__) do
      {:ok, ant} -> ant
      error -> error
    end
  end

  def init(state) do
    {:ok, state}
  end
end
