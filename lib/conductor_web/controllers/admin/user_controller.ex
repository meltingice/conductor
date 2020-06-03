defmodule ConductorWeb.Admin.UserController do
  use ConductorWeb, :controller
  alias Conductor.User
  import Ecto.Query

  def index(conn, params) do
    page =
      User
      |> order_by(asc: :first_name, asc: :last_name)
      |> Conductor.Repo.paginate(params)

    render(conn, "index.html", users: page.entries, page_number: page.page_number)
  end
end
