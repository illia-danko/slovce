defmodule Slivce.Repo do
  use Ecto.Repo,
    otp_app: :slivce,
    adapter: Ecto.Adapters.Postgres
end
