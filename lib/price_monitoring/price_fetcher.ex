# lib/your_app/price_fetcher.ex
defmodule PriceMonitoring.PriceFetcher do
  use GenServer
  alias PriceMonitoring.Repo
  alias PriceMonitoring.Market.Price
  require Logger

  @coingecko_url "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,nervos-network,ethereum&vs_currencies=usd"

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    schedule_fetch()
    {:ok, %{}}
  end

  def handle_info(:fetch_prices, state) do
    fetch_and_store_prices()
    schedule_fetch()
    {:noreply, state}
  end

  defp schedule_fetch do
    # 每分钟获取一次价格
    Process.send_after(self(), :fetch_prices, 60_000)
  end

  defp fetch_and_store_prices do
    case HTTPoison.get(@coingecko_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok,
           %{
             "bitcoin" => %{"usd" => btc_price},
             "nervos-network" => %{"usd" => ckb_price},
             "ethereum" => %{"usd" => eth_price}
           }} ->
            %Price{
              btc_price: btc_price / 1.0,
              ckb_price: ckb_price / 1.0,
              eth_price: eth_price / 1.0
            }
            |> Repo.insert()

            Logger.info("Prices fetched and stored successfully")

          {:error, _} ->
            Logger.error("Failed to decode JSON response")
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("HTTP request failed: #{reason}")
    end
  end
end
