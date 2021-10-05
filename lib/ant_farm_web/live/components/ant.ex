defmodule AntFarmWeb.Live.Components.Ant do
  use AntFarmWeb, :live_component

  def render(assigns) do
    ~H"""
    <circle
      r={@size}
      fill={@color}
      cx={@x}
      cy={@y}
    />
    """
  end
end
