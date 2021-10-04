defmodule AntFarmWeb.Live.PageLive do
  use AntFarmWeb, :live_view

  alias AntFarmWeb.Live.Components
  alias AntFarm.Colony

  def mount(_args, _session, socket) do
    Colony.add!(id: 0, position: {50, 50})
    Colony.add!(id: 1, position: {100, 50})
    Colony.add!(id: 2, position: {150, 150})
    Colony.add!(id: 3, position: {350, 250})
    Colony.add!(id: 4, position: {450, 450})
    Colony.add!(id: 5, position: {650, 850})

    {:ok, socket |> assign_ants()}
  end

  def render(assigns) do
    ~H"""
    <div class="main-content">
      <h2>Rendering <%= @ant_count %> concurrent ants</h2>
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

  defp assign_ants(socket),
    do:
      socket
      |> assign(:ants, Colony.ants())
      |> assign(:ant_count, Colony.ant_count())
end
