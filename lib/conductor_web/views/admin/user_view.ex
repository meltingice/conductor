defmodule ConductorWeb.Admin.UserView do
  use ConductorWeb, :view

  def full_name(user) do
    String.trim("#{user.first_name} #{user.last_name}")
  end
end
