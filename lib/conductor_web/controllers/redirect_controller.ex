defmodule ConductorWeb.RedirectController do
  use ConductorWeb, :controller

  def index(conn, _params) do
    # TODO - make this configurable?
    redirect(conn, external: "https://www.hodinkee.com")
  end

  def show(conn, %{"code" => code}) do
    Conductor.Repo.get_by(Conductor.Redirect, code: code)
    |> case do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ConductorWeb.ErrorView)
        |> render(:"404")

      record ->
        # TODO - record view
        conn |> redirect(external: record.destination)
    end
  end
end
