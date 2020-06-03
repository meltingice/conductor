defmodule Conductor.Redirect do
  use Conductor.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "redirects" do
    field :active, :boolean, default: true
    field :code, :string
    field :destination, :string
    field :name, :string
    field :views, :integer, default: 0
  end

  @doc false
  def changeset(redirect, attrs) do
    redirect
    |> cast(attrs, [:active, :code, :destination, :name, :views])
    |> validate_required([:active, :code, :name, :destination])
  end
end
