defmodule PriceMonitoringWeb.PriceJSON do
  alias PriceMonitoring.Market.Price

  @doc """
  Renders a list of prices.
  """
  def index(%{prices: prices}) do
    %{data: for(price <- prices, do: data(price))}
  end

  @doc """
  Renders a single price.
  """
  def show(%{price: price}) do
    %{data: data(price)}
  end

  defp data(%Price{} = price) do
    %{
      id: price.id,
      btc_price: price.btc_price,
      ckb_price: price.ckb_price,
      eth_price: price.eth_price
    }
  end
end
