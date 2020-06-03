defmodule ConductorWeb.UserAuth do
  use ConductorWeb, :controller

  alias Conductor.Repo
  alias Conductor.User
  alias ConductorWeb.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in UserToken.
  # @max_age 60 * 60 * 24 * 60
  # @remember_me_cookie "user_remember_me"
  # @remember_me_options [sign: true, max_age: @max_age]

  def login_user(conn, user) do
    conn
    |> renew_session()
    |> put_session(:current_user_id, user.id)
  end

  def logout_user(conn) do
    conn |> renew_session()
  end

  def fetch_current_user(conn, _opts) do
    {user_id, conn} = ensure_user_id(conn)
    user = user_id && Repo.get(User, user_id)

    assign(conn, :current_user, user)
  end

  # TODO - implement remember me cookie
  def ensure_user_id(conn) do
    if user_id = get_session(conn, :current_user_id) do
      {user_id, conn}
    else
      {nil, conn}
    end
  end

  def require_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must login to access this page.")
      |> redirect(to: Routes.auth_path(conn, :login))
    end
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defmodule Helpers do
    def current_user(conn) do
      conn.assigns[:current_user]
    end
  end
end
