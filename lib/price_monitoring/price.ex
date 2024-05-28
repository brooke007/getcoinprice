defmodule PriceMonitoring.Price do
  use Ecto.Schema
  import Ecto.Changeset

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
