defmodule ConductorWeb.Admin.RedirectController do
  use ConductorWeb, :controller
  alias Conductor.Redirect
  import Ecto.Query

  def index(conn, params) do
    page =
      Redirect
      |> order_by(desc: :inserted_at)
      |> Conductor.Repo.paginate(params)

    render(conn, "index.html", redirects: page.entries, page_number: page.page_number)
  end
end
