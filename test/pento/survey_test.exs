defmodule Pento.SurveyTest do
  use Pento.DataCase

  alias Pento.{Accounts, Catalog, Survey}

  describe "demographics" do
    alias Pento.Survey.Demographic

    @valid_attrs %{gender: "other", year_of_birth: 1942}
    @update_attrs %{gender: "prefer not to say", year_of_birth: 1943}
    @invalid_attrs %{gender: nil, year_of_birth: nil}

    def demographic_fixture(attrs \\ %{}) do
      {:ok, user} = Accounts.register_user(%{email: "test@test.com", password: "abcdef123456"})
      {:ok, demographic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:user_id, user.id)
        |> Survey.create_demographic()

      demographic
    end

    test "list_demographics/0 returns all demographics" do
      demographic = demographic_fixture()
      assert Survey.list_demographics() == [demographic]
    end

    test "get_demographic!/1 returns the demographic with given id" do
      demographic = demographic_fixture()
      assert Survey.get_demographic!(demographic.id) == demographic
    end

    test "create_demographic/1 with valid data creates a demographic" do
      {:ok, user} = Accounts.register_user(%{email: "test2@test.com", password: "abcdef123456"})
      assert {:ok, %Demographic{} = demographic} = Survey.create_demographic(@valid_attrs |> Map.put(:user_id, user.id))
      assert demographic.gender == "other"
      assert demographic.year_of_birth == 1942
    end

    test "create_demographic/1 with invalid data returns error changeset" do
      {:ok, user} = Accounts.register_user(%{email: "test2@test.com", password: "abcdef123456"})
      assert {:error, %Ecto.Changeset{}} = Survey.create_demographic(@invalid_attrs |> Map.put(:user_id, user.id))
    end

    test "update_demographic/2 with valid data updates the demographic" do
      demographic = demographic_fixture()
      assert {:ok, %Demographic{} = demographic} = Survey.update_demographic(demographic, @update_attrs)
      assert demographic.gender == "prefer not to say"
      assert demographic.year_of_birth == 1943
    end

    test "update_demographic/2 with invalid data returns error changeset" do
      demographic = demographic_fixture()
      assert {:error, %Ecto.Changeset{}} = Survey.update_demographic(demographic, @invalid_attrs)
      assert demographic == Survey.get_demographic!(demographic.id)
    end

    test "delete_demographic/1 deletes the demographic" do
      demographic = demographic_fixture()
      assert {:ok, %Demographic{}} = Survey.delete_demographic(demographic)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_demographic!(demographic.id) end
    end

    test "change_demographic/1 returns a demographic changeset" do
      demographic = demographic_fixture()
      assert %Ecto.Changeset{} = Survey.change_demographic(demographic)
    end
  end

  describe "ratings" do
    alias Pento.Survey.Rating

    @valid_attrs %{stars: 2}
    @update_attrs %{stars: 3}
    @invalid_attrs %{stars: nil}

    def rating_fixture(attrs \\ %{}) do
      {:ok, user} = Accounts.register_user(%{email: "test@test.com", password: "abcdef123456"})
      {:ok, product} = Catalog.create_product(%{description: "test", name: "test", sku: 1, unit_price: 1})
      {:ok, rating} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:product_id, product.id)
        |> Map.put(:user_id, user.id)
        |> Survey.create_rating()

      rating
    end

    test "list_ratings/0 returns all ratings" do
      rating = rating_fixture()
      assert Survey.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id" do
      rating = rating_fixture()
      assert Survey.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating" do
      {:ok, user} = Accounts.register_user(%{email: "test2@test.com", password: "abcdef123456"})
      {:ok, product} = Catalog.create_product(%{description: "test2", name: "test2", sku: 2, unit_price: 2})
      assert {:ok, %Rating{} = rating} = Survey.create_rating(@valid_attrs |> Map.put(:user_id, user.id) |> Map.put(:product_id, product.id))
      assert rating.stars == 2
    end

    test "create_rating/1 with invalid data returns error changeset" do
      {:ok, user} = Accounts.register_user(%{email: "test2@test.com", password: "abcdef123456"})
      {:ok, product} = Catalog.create_product(%{description: "test2", name: "test2", sku: 2, unit_price: 2})
      assert {:error, %Ecto.Changeset{}} = Survey.create_rating(@invalid_attrs |> Map.put(:user_id, user.id) |> Map.put(:product_id, product.id))
    end

    test "update_rating/2 with valid data updates the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{} = rating} = Survey.update_rating(rating, @update_attrs)
      assert rating.stars == 3
    end

    test "update_rating/2 with invalid data returns error changeset" do
      rating = rating_fixture()
      assert {:error, %Ecto.Changeset{}} = Survey.update_rating(rating, @invalid_attrs)
      assert rating == Survey.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{}} = Survey.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset" do
      rating = rating_fixture()
      assert %Ecto.Changeset{} = Survey.change_rating(rating)
    end
  end
end
