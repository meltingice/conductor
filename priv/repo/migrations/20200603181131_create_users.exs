defmodule Conductor.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :active, :boolean, default: false, null: false

      timestamps()
    end

    create index(:users, [:email], unique: true)
  end
end
