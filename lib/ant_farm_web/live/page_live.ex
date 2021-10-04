defmodule AntFarmWeb.Live.PageLive do
  use AntFarmWeb, :live_view

  alias AntFarmWeb.Live.Components
  alias AntFarm.Ant.Core, as: Ant

  def mount(_args, _session, socket) do
    ants = [
      %Ant{id: 0, position: {50, 50}},
      %Ant{id: 1, position: {100, 50}},
      %Ant{id: 2, position: {150, 150}},
      %Ant{id: 3, position: {350, 250}},
      %Ant{id: 4, position: {450, 450}},
      %Ant{id: 5, position: {650, 850}}
    ]

    IO.inspect(ants)

    socket =
      socket
      |> assign(:ants, ants)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="main-content">
      <h2>Rendering <%= length(@ants) %> concurrent ants</h2>
      <%= live_component Components.Colony,
        width: 1024,
        height: 600,
        background_color: "green",
        ants: @ants,
        ant_size: 2,
        ant_color: "#000000"
      %>
    </div>
    """
  end
end
