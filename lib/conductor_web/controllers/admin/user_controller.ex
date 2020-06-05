defmodule ConductorWeb.Admin.UserController do
  use ConductorWeb, :controller
  alias Conductor.{Repo, User}
  import Ecto.Query

  def index(conn, params) do
    page =
      User
      |> order_by(asc: :first_name, asc: :last_name)
      |> Repo.paginate(params)

    render(conn, "index.html", users: page.entries, page_number: page.page_number)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def create(conn, %{"user" => params}) do
    changeset = User.changeset(%User{}, user_params(params))

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "The user has been created")
        |> redirect(to: Routes.admin_user_path(conn, :show, user.id))

      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params(params))

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "The user has been updated.")
        |> redirect(to: Routes.admin_user_path(conn, :show, user.id))

      {:error, changeset} ->
        conn |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    case Repo.delete(user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "The user has been deleted.")
        |> redirect(to: Routes.admin_user_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "There was an error deleting the user.")
        |> redirect(to: Routes.admin_user_path(conn, :index))
    end
  end

  defp user_params(user) do
    StrongParams.extract(user, ["email", "first_name", "last_name", "active"])
  end
end
