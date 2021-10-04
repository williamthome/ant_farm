defmodule AntFarmWeb.Live.PageLive do
  use AntFarmWeb, :live_view

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
      <svg viewbox="0 0 1024 600">
        <rect width="1024" height="600" fill="#00b349"/>
        <%= for %Ant{position: {x, y}} <- @ants do %>
          <rect width="2" height="2" fill="#000000" x={x} y={y}/>
        <% end %>
      </svg>
    </div>
    """
  end
end
