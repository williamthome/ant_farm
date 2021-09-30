defmodule AntFarmWeb.PageController do
  use AntFarmWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
