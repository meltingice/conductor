defmodule Conductor.Repo.Migrations.RenameRedirectViewsToViewsCount do
  use Ecto.Migration

  def change do
    rename table("redirects"), :views, to: :views_count
  end
end
