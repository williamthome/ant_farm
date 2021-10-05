defmodule AntFarmWeb.Live.PageLive do
  use AntFarmWeb, :live_view

  alias AntFarmWeb.Live.Components
  alias AntFarm.{Ant, Colony}

  @ants 100
  @speed_range 1..3

  @one_second 1_000
  @fps 30
  @timeout round(@one_second / @fps)

  @config %{
    colony_width: 1024,
    colony_height: 600,
    colony_color: "green",
    ant_size: 2,
    ant_color: "black"
  }

  def mount(_args, _session, socket) do
    spawn_ants(@ants, speed_range: @speed_range)

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

  defp assign_ants(socket) do
    ants =
      Colony.ants()
      |> Task.async_stream(fn ant ->
        if ant.position |> out_of_bounds(), do: ant.id |> Ant.rotate(180)
        ant
      end)
      |> Enum.map(fn {:ok, ant} -> ant end)

    socket
    |> assign(:ants, ants)
    |> assign(:ant_count, Colony.ant_count())
  end

  def handle_info(:tick, socket) do
    socket =
      socket
      |> assign_ants()

    schedule()

    {:noreply, socket}
  end

  defp schedule,
    do: Process.send_after(self(), :tick, @timeout)

  defp spawn_ants(count, speed_range: speed_range) do
    Colony.unpopulate()

    for id <- 1..count do
      Colony.add!(
        id: id,
        position: {
          Enum.random(0..@config.colony_width),
          Enum.random(0..@config.colony_height)
        },
        speed: Enum.random(speed_range),
        direction: Enum.random(0..360)
      )
    end
  end

  defp out_of_bounds({x, y}),
    do: x < 0 or x > @config.colony_width or y < 0 or y > @config.colony_height
end
