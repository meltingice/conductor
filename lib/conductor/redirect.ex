defmodule Conductor.Redirect do
  use Conductor.Schema
  import Ecto.Changeset
  alias Conductor.{Cache, Repo}

  @derive {Jason.Encoder, only: [:id, :code, :destination, :views_count]}
  schema "redirects" do
    field :active, :boolean, default: true
    field :code, :string
    field :destination, :string
    field :name, :string
    field :views_count, :integer, default: 0

    has_many :views, Conductor.Redirect.View

    timestamps()
  end

  def view_count(%Conductor.Redirect{} = redirect) do
    redirect |> Ecto.assoc(:views) |> Repo.aggregate(:count, :id)
  end

  def clear_cache(%Conductor.Redirect{} = redirect) do
    Cache.delete(cache_key(redirect.code))
  end

  def cache_key(code) do
    "redirect/v2/#{code}"
  end

  @doc false
  def changeset(redirect, attrs \\ %{}) do
    redirect
    |> cast(attrs, [:active, :code, :destination, :name, :views_count])
    |> validate_required([:active, :code, :name, :destination])
    |> unique_constraint(:code)
  end
end
