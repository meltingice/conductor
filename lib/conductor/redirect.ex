defmodule Conductor.Redirect do
  use Conductor.Schema
  import Ecto.Changeset

  schema "redirects" do
    field :code, :string
    field :destination, :string
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(redirect, attrs) do
    redirect
    |> cast(attrs, [:code, :destination, :views])
    |> validate_required([:code, :destination])
  end
end
