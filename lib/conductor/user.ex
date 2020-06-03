defmodule Conductor.User do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  alias Ueberauth.Auth

  schema "users" do
    field :active, :boolean, default: false
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  def from_auth(%Auth{provider: :google, info: info}) do
    User
    |> Ecto.Query.where(active: true, email: ^info.email)
    |> Ecto.Query.first()
    |> Conductor.Repo.one()
    |> case do
      nil ->
        {:error, "User not found or not active for login"}

      user ->
        {:ok, user}
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :active])
    |> validate_required([:email, :first_name, :last_name, :active])
  end
end
