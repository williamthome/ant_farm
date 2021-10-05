defmodule AntFarmWeb.Live.PageLive do
  use AntFarmWeb, :live_view

  alias AntFarmWeb.Live.Components
  alias AntFarm.Colony

  @one_second 1_000
  @fps 20
  @timeout round(@one_second / @fps)

  @config %{
    colony_width: 1024,
    colony_height: 600,
    colony_color: "green",
    ant_size: 2,
    ant_color: "black"
  }

  def mount(_args, _session, socket) do
    Colony.add!(id: 0, position: {50, 50})
    Colony.add!(id: 1, position: {100, 50})
    Colony.add!(id: 2, position: {150, 150})
    Colony.add!(id: 3, position: {350, 250})
    Colony.add!(id: 4, position: {450, 450})
    Colony.add!(id: 5, position: {650, 850})

    schedule()

    socket =
      socket
      |> assign(@config)
      |> assign_ants()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="main-content">
      <h2>Rendering <%= @ant_count %> concurrent ants</h2>
      <%= live_component Components.Colony,
        id: "colony",
        width: @colony_width,
        height: @colony_height,
        background_color: @colony_color,
        ants: @ants,
        ant_size: @ant_size,
        ant_color: @ant_color
      %>
    </div>
    """
  end

  defp assign_ants(socket),
    do:
      socket
      |> assign(:ants, Colony.ants())
      |> assign(:ant_count, Colony.ant_count())

  def handle_info(:tick, socket) do
    schedule()

    {:noreply, socket |> assign_ants()}
  end

  defp schedule,
    do: Process.send_after(self(), :tick, @timeout)
end
