defmodule Conductor.Redirect.View do
  use Conductor.Schema
  import Ecto.Changeset
  alias Conductor.{Repo}

  schema "redirect_views" do
    field :ip_address, :string
    field :user_agent, :string

    belongs_to :redirect, Conductor.Redirect

    timestamps()
  end

  def record(conn, %{id: redirect_id}) do
    record(conn, redirect_id)
  end

  def record(conn, %{"id" => redirect_id}) do
    record(conn, redirect_id)
  end

  def record(conn, redirect_id) when is_binary(redirect_id) do
    ip_address =
      case Plug.Conn.get_req_header(conn, "x-forwarded-for") |> List.first() do
        nil ->
          remote_ip_to_string(conn.remote_ip)

        forwarded_for ->
          forwarded_for |> String.split(",") |> List.first() |> String.trim()
      end

    %Conductor.Redirect.View{
      redirect_id: redirect_id,
      ip_address: ip_address,
      user_agent: Plug.Conn.get_req_header(conn, "user-agent") |> List.first()
    }
    |> Repo.insert()

    conn
  end

  @doc false
  def changeset(view, attrs) do
    view
    |> cast(attrs, [:redirect_id, :ip_address, :user_agent])
    |> validate_required([:redirect_id, :ip_address, :user_agent])
  end

  defp remote_ip_to_string(remote_ip) do
    remote_ip |> :inet_parse.ntoa() |> to_string()
  end
end
