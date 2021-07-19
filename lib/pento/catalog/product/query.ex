defmodule Pento.Catalog.Product.Query do
  import Ecto.Query

  alias Pento.Accounts.User
  alias Pento.Catalog.Product
  alias Pento.Survey.{Demographic, Rating}

  def base, do: Product

  defp average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, fragment("?::float", avg(r.stars))})
  end

  def filter_by_age_group(query, {nil, birth_year_max}) do
    query
    |> where([_p, _r, _u, d], d.year_of_birth >= ^birth_year_max)
  end
  def filter_by_age_group(query, {birth_year_min, nil}) do
    query
    |> where([_p, _r, _u, d], d.year_of_birth <= ^birth_year_min)
  end
  def filter_by_age_group(query, {birth_year_min, birth_year_max}) do
    query
    |> where(
      [_p, _r, _u, d],
      d.year_of_birth >= ^birth_year_min and d.year_of_birth <= ^birth_year_max
    )
  end
  def filter_by_age_group(query, _filter) do
    query
  end

  def join_demographics(query \\ base()) do
    query
    |> join(:left, [_p, _r, u, d], d in Demographic, on: d.user_id == u.id)
  end

  defp join_ratings(query) do
    query
    |> join(:inner, [p], r in Rating, on: r.product_id == p.id)
  end

  def join_users(query \\ base()) do
    query
    |> join(:left, [_p, r], u in User, on: r.user_id == u.id)
  end

  def with_average_ratings(query \\ base()) do
    query
    |> join_ratings()
    |> average_ratings()
  end

  def with_user_ratings(query \\ base(), user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end

  def with_zero_ratings(query \\ base()) do
    query
    |> select([p], {p.name, 0})
  end
end
