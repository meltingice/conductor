defmodule ConductorWeb.AuthController do
  use ConductorWeb, :controller
  alias ConductorWeb.UserAuth

  plug Ueberauth

  action_fallback ConductorWeb.ErrorController

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def logout(conn, _params) do
    conn |> UserAuth.logout_user() |> redirect(to: Routes.auth_path(conn, :login))
  end

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
        |> UserAuth.login_user(user)
        |> redirect(to: "/admin")
    end
  end
end
