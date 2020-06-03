defmodule Conductor.Repo do
  use Ecto.Repo,
    otp_app: :conductor,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
