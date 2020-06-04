defmodule ConductorWeb.RedirectController do
  use ConductorWeb, :controller
  alias Conductor.{Repo, Redirect}

  action_fallback ConductorWeb.ErrorController

  def index(conn, _params) do
    System.get_env("DEFAULT_REDIRECT")
    |> case do
      nil ->
        {:error, :not_found}

      destination ->
        redirect(conn, external: destination)
    end
  end

  def show(conn, %{"code" => code}) do
    Repo.get_by(Redirect, code: code)
    |> case do
      nil ->
        {:error, :not_found}

      record ->
        # TODO - record view
        conn |> redirect(external: record.destination)
    end
  end
end
