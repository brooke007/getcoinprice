defmodule PriceMonitoring.MarketTest do
  use PriceMonitoring.DataCase

  alias PriceMonitoring.Market

  describe "prices" do
    alias PriceMonitoring.Market.Price

    import PriceMonitoring.MarketFixtures

    @invalid_attrs %{btc_price: nil, ckb_price: nil, eth_price: nil}

    test "list_prices/0 returns all prices" do
      price = price_fixture()
      assert Market.list_prices() == [price]
    end

    test "get_price!/1 returns the price with given id" do
      price = price_fixture()
      assert Market.get_price!(price.id) == price
    end

    test "create_price/1 with valid data creates a price" do
      valid_attrs = %{btc_price: 120.5, ckb_price: 120.5, eth_price: 120.5}

      assert {:ok, %Price{} = price} = Market.create_price(valid_attrs)
      assert price.btc_price == 120.5
      assert price.ckb_price == 120.5
      assert price.eth_price == 120.5
    end

    test "create_price/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_price(@invalid_attrs)
    end

    test "update_price/2 with valid data updates the price" do
      price = price_fixture()
      update_attrs = %{btc_price: 456.7, ckb_price: 456.7, eth_price: 456.7}

      assert {:ok, %Price{} = price} = Market.update_price(price, update_attrs)
      assert price.btc_price == 456.7
      assert price.ckb_price == 456.7
      assert price.eth_price == 456.7
    end

    test "update_price/2 with invalid data returns error changeset" do
      price = price_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_price(price, @invalid_attrs)
      assert price == Market.get_price!(price.id)
    end

    test "delete_price/1 deletes the price" do
      price = price_fixture()
      assert {:ok, %Price{}} = Market.delete_price(price)
      assert_raise Ecto.NoResultsError, fn -> Market.get_price!(price.id) end
    end

    test "change_price/1 returns a price changeset" do
      price = price_fixture()
      assert %Ecto.Changeset{} = Market.change_price(price)
    end
  end
end
