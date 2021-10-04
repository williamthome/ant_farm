defmodule AntFarmWeb.Live.Components.Colony do
  use AntFarmWeb, :live_component

  alias AntFarmWeb.Live.Components
  alias AntFarm.Ant.Core, as: Ant

  def render(assigns) do
    ~H"""
    <svg viewbox={"0 0 #{@width} #{@height}"}>
      <rect width={@width} height={@height} fill={@background_color}/>
      <%= for %Ant{position: {x, y}} <- @ants do %>
        <%= live_component Components.Ant,
          size: @ant_size,
          color: @ant_color,
          x: x,
          y: y
        %>
      <% end %>
    </svg>
    """
  end
end
