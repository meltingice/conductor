defmodule ConductorWeb.ErrorController do
  use ConductorWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ConductorWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ConductorWeb.ErrorView)
    |> render(:"401")
  end
end
