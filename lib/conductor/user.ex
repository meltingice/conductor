defmodule Conductor.User do
  use Conductor.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Ueberauth.Auth
  alias Conductor.Repo

  schema "users" do
    field :active, :boolean, default: false
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  def from_auth(%Auth{provider: :google, info: info}) do
    Conductor.User
    |> Conductor.User.active()
    |> Conductor.User.for_email(info.email)
    |> first()
    |> Repo.one()
    |> case do
      nil ->
        {:error, "User not found or not active for login"}

      user ->
        {:ok, user}
    end
  end

  def active(query) do
    query |> where(active: true)
  end

  def for_email(query, email) do
    query |> where(email: ^email)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :active])
    |> validate_required([:email, :first_name, :last_name, :active])
  end
end
