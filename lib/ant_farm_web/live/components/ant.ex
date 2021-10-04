defmodule AntFarmWeb.Live.Components.Ant do
  use AntFarmWeb, :live_component

  def render(assigns) do
    ~H"""
    <rect
      width={@size}
      height={@size}
      fill={@color}
      x={@x}
      y={@y}
    />
    """
  end
end
