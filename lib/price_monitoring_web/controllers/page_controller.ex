defmodule PriceMonitoringWeb.PageController do
  use PriceMonitoringWeb, :controller

  alias PriceMonitoring.Market


  def index(conn, _params) do
    prices = Market.list_prices()
    render(conn, "index.html", prices: prices)
  end
end
