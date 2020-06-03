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
    |> cast(attrs, [:code, :destination, :views])
    |> validate_required([:code, :destination])
  end
end
