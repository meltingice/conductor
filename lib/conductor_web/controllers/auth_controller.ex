defmodule ConductorWeb.AuthController do
  use ConductorWeb, :controller
  plug Ueberauth

  action_fallback ConductorWeb.ErrorController

  def callback(%{assigns: %{ueberauth_failure: _fails}}, _params) do
    {:error, :unauthorized}
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    Conductor.User.from_auth(auth)
    |> case do
      {:error, _reason} ->
        {:error, :unauthorized}

      {:ok, %Conductor.User{} = user} ->
        conn
        |> put_flash(:info, "You are now logged in.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/admin")
    end
  end
end
