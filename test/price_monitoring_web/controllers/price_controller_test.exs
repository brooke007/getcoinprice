defmodule PriceMonitoringWeb.PriceControllerTest do
  use PriceMonitoringWeb.ConnCase

  import PriceMonitoring.MarketFixtures

  alias PriceMonitoring.Market.Price

  @create_attrs %{
    btc_price: 120.5,
    ckb_price: 120.5,
    eth_price: 120.5
  }
  @update_attrs %{
    btc_price: 456.7,
    ckb_price: 456.7,
    eth_price: 456.7
  }
  @invalid_attrs %{btc_price: nil, ckb_price: nil, eth_price: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all prices", %{conn: conn} do
      conn = get(conn, ~p"/api/prices")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create price" do
    test "renders price when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/prices", price: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/prices/#{id}")

      assert %{
               "id" => ^id,
               "btc_price" => 120.5,
               "ckb_price" => 120.5,
               "eth_price" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/prices", price: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update price" do
    setup [:create_price]

    test "renders price when data is valid", %{conn: conn, price: %Price{id: id} = price} do
      conn = put(conn, ~p"/api/prices/#{price}", price: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/prices/#{id}")

      assert %{
               "id" => ^id,
               "btc_price" => 456.7,
               "ckb_price" => 456.7,
               "eth_price" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, price: price} do
      conn = put(conn, ~p"/api/prices/#{price}", price: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete price" do
    setup [:create_price]

    test "deletes chosen price", %{conn: conn, price: price} do
      conn = delete(conn, ~p"/api/prices/#{price}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/prices/#{price}")
      end
    end
  end

  defp create_price(_) do
    price = price_fixture()
    %{price: price}
  end
end
