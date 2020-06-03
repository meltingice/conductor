defmodule ConductorWeb.Admin.HomeController do
  use ConductorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
