defmodule Ibento.Repo do
  use Ecto.Repo,
    otp_app: :ibento,
    adapter: Ecto.Adapters.Postgres
end
