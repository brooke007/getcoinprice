defmodule PriceMonitoring.Repo do
  use Ecto.Repo,
    otp_app: :price_monitoring,
    adapter: Ecto.Adapters.Postgres
end
