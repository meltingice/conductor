defmodule Conductor.Repo.Migrations.CreateRedirectViews do
  use Ecto.Migration

  def change do
    create table(:redirect_views, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :redirect_id, references(:redirects, type: :uuid)
      add :ip_address, :string
      add :user_agent, :string

      timestamps()
    end

    create index(:redirect_views, [:redirect_id])
  end
end
