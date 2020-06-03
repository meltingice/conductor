defmodule Conductor.Repo.Migrations.AddNameAndActiveToRedirects do
  use Ecto.Migration

  def change do
    alter table(:redirects) do
      add :name, :string
      add :active, :boolean, default: true
    end
  end
end
