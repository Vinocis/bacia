defmodule Bacia.Repo do
  use Ecto.Repo,
    otp_app: :bacia,
    adapter: Ecto.Adapters.Postgres
end
