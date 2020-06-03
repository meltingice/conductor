defmodule ConductorWeb.RedirectController do
  use ConductorWeb, :controller

  action_fallback ConductorWeb.ErrorController

  def index(conn, _params) do
    # TODO - make this configurable?
    redirect(conn, external: "https://www.hodinkee.com")
  end

  def show(conn, %{"code" => code}) do
    Conductor.Repo.get_by(Conductor.Redirect, code: code)
    |> case do
      nil ->
        {:error, :not_found}

      record ->
        # TODO - record view
        conn |> redirect(external: record.destination)
    end
  end
end
