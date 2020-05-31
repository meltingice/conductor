defmodule Conductor.Repo.Migrations.CreateRedirects do
  use Ecto.Migration

  def change do
    create table(:redirects, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :code, :string
      add :destination, :text
      add :views, :integer, default: 0

      timestamps()
    end

    create index(:redirects, [:code], unique: true)
  end
end
