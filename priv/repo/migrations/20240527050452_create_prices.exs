defmodule PriceMonitoring.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:prices) do
      add :btc_price, :float
      add :ckb_price, :float
      add :eth_price, :float

      timestamps(type: :utc_datetime)
    end
  end
end
