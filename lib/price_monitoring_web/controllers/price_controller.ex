defmodule PriceMonitoringWeb.PriceController do
  use PriceMonitoringWeb, :controller

  alias PriceMonitoring.Market
  alias PriceMonitoring.Market.Price

  action_fallback PriceMonitoringWeb.FallbackController

  def index(conn, _params) do
    prices = Market.list_prices()
    json(conn, %{data: prices})
  end

  def create(conn, %{"price" => price_params}) do
    with {:ok, %Price{} = price} <- Market.create_price(price_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.price_path(conn, :show, price))
      |> json(%{data: price})
    end
  end

  def show(conn, %{"id" => id}) do
    price = Market.get_price!(id)
    json(conn, %{data: price})
  end

  def update(conn, %{"id" => id, "price" => price_params}) do
    price = Market.get_price!(id)

    with {:ok, %Price{} = price} <- Market.update_price(price, price_params) do
      json(conn, %{data: price})
    end
  end

  def delete(conn, %{"id" => id}) do
    price = Market.get_price!(id)

    with {:ok, %Price{}} <- Market.delete_price(price) do
      send_resp(conn, :no_content, "")
    end
  end
end
