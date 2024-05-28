defmodule PriceMonitoring.MarketFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PriceMonitoring.Market` context.
  """

  @doc """
  Generate a price.
  """
  def price_fixture(attrs \\ %{}) do
    {:ok, price} =
      attrs
      |> Enum.into(%{
        btc_price: 120.5,
        ckb_price: 120.5,
        eth_price: 120.5
      })
      |> PriceMonitoring.Market.create_price()

    price
  end
end
