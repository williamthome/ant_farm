defmodule AntFarmWeb.Live.PageLive do
  use AntFarmWeb, :live_view

  alias AntFarmWeb.Live.Components
  alias AntFarm.{Ant, Colony}

  @initial_ant_count 100
  @speed_range 1..3

  @one_second 1_000
  @fps 30
  @timeout round(@one_second / @fps)

  @config %{
    colony_width: 1024,
    colony_height: 600,
    colony_color: "green",
    ant_size: 2,
    ant_color: "black",
    population_limit: 500
  }

  def mount(_args, _session, socket) do
    spawn_ants(@initial_ant_count)

    schedule()

    socket =
      socket
      |> assign(@config)
      |> assign_ants()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <header>
      <h1 style="display: inline-block; margin: 1rem 0;">Ant Farm</h1>
      <a
        class="repository-link"
        href="https://github.com/williamthome/ant_farm"
        target="_blank"
      >
        <svg width="32" height="32" viewBox="0 0 16 16">
          <path
            fill-rule="evenodd"
            d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"
          >
          </path>
        </svg>
      </a>
    </header>
    <div class="main-content">
      <form
        phx-change="spawn_ants"
        onkeydown="return event.key != 'Enter';"
      >
        <h2 class="concurrency-title">
          <span>Rendering</span>
          <input
            type="number"
            name="count"
            value={@ant_count}
            min={1}
            max={@population_limit}
            style="margin-bottom: 0;"
          />
          <span>concurrent ants</span>
        </h2>
      </form>
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
    <footer>
      <a href="http://github.com/williamthome">@williamthome</a>
    </footer>
    """
  end

  def handle_event("spawn_ants", %{"count" => count}, socket) do
    count = count |> String.to_integer()
    limit = socket.assigns.population_limit

    socket =
      case count <= limit do
        true ->
          spawn_ants(count)
          socket |> clear_flash()

        false ->
          socket |> put_flash(:error, "Population limit is #{limit}")
      end

    {:noreply, socket}
  rescue
    ArgumentError ->
      spawn_ants(1)
      {:noreply, socket}
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

  defp spawn_ants(count) do
    Colony.unpopulate()

    for id <- 1..count do
      Colony.add!(
        id: id,
        position: {
          Enum.random(0..@config.colony_width),
          Enum.random(0..@config.colony_height)
        },
        speed: Enum.random(@speed_range),
        direction: Enum.random(0..360)
      )
    end
  end

  defp out_of_bounds({x, y}),
    do: x < 0 or x > @config.colony_width or y < 0 or y > @config.colony_height
end
