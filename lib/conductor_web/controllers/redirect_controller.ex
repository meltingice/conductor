defmodule ConductorWeb.RedirectController do
  use ConductorWeb, :controller

  def index(conn, _params) do
    # TODO - make this configurable?
    redirect(conn, external: "https://www.hodinkee.com")
  end

  def show(conn, %{"code" => code}) do
  end
end
