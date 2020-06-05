defmodule ConductorWeb.RedirectController do
  use ConductorWeb, :controller
  alias Conductor.{Cache, Repo, Redirect}

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
    Cache.fetch(Redirect.cache_key(code), fn ->
      case Repo.get_by(Redirect, code: code) do
        %Redirect{} = redirect ->
          {:ok, redirect.destination}

        _ ->
          {:error, :not_found}
      end
    end)
    |> case do
      {:ok, destination} ->
        # TODO - record view
        conn |> redirect(external: destination)

      err ->
        err
    end
  end
end
