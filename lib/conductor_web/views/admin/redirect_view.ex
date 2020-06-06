defmodule ConductorWeb.Admin.RedirectView do
  use ConductorWeb, :view

  def view_count(redirect) do
    Number.Delimit.number_to_delimited(redirect.views_count, precision: 0)
  end
end
