defmodule Conductor.Redirect.View do
  use Conductor.Schema
  import Ecto.Changeset

  schema "redirect_views" do
    field :ip_address, :string
    field :user_agent, :string

    belongs_to :redirect, Conductor.Redirect

    timestamps()
  end

  @doc false
  def changeset(view, attrs) do
    view
    |> cast(attrs, [:redirect_id, :ip_address, :user_agent])
    |> validate_required([:redirect_id, :ip_address, :user_agent])
  end
end
