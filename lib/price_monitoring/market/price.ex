defmodule PriceMonitoring.Market.Price do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:id, :btc_price, :ckb_price, :eth_price, :inserted_at, :updated_at]}
  schema "prices" do
    field :btc_price, :float
    field :ckb_price, :float
    field :eth_price, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:btc_price, :ckb_price, :eth_price])
    |> validate_required([:btc_price, :ckb_price, :eth_price])
  end
end
