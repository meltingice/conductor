defmodule ConductorWeb.Admin.RedirectView do
  use ConductorWeb, :view
  alias Conductor.Redirect

  def delimited_view_count(view_count) do
    Number.Delimit.number_to_delimited(view_count, precision: 0)
  end
end
