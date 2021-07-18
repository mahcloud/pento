defmodule PentoWeb.RatingLive.RatingComponent do
  use PentoWeb, :live_component

	alias Pento.Survey
	alias Pento.Survey.Rating

	def handle_event("rate", %{"stars" => stars}, %{assigns: %{product: product, product_index: product_index, rating: %{id: nil} = rating}} = socket) do
		case Survey.create_rating(rating |> Map.put(:stars, stars)) do
			{:ok, rating} ->
				product = %{product | ratings: [rating]}
				send(self(), {:product_rating, product, product_index})
				socket
		end

		{:noreply, socket}
	end
	def handle_event("rate", %{"stars" => stars}, %{assigns: %{product: product, product_index: product_index, rating: rating}} = socket) do
		case Survey.update_rating(rating, %{stars: stars}) do
			{:ok, rating} ->
				product = %{product | ratings: [rating]}
				send(self(), {:product_rating, product, product_index})
				socket
		end

		{:noreply, socket}
	end

	def update(assigns, socket) do
		{:ok,
			socket
			|> assign(assigns)
			|> assign_rating()
		}
	end

	def get_star_classes(%{index: index, rating: %{stars: stars}}) when index >= stars do
		"far fa-star"
	end
	def get_star_classes(%{index: index, rating: %{stars: stars}}) do
		"fas fa-star"
	end

	defp assign_rating(%{assigns: %{current_user: user, product: product, rating: nil}} = socket) do
		socket
		|> assign(:rating, %{id: nil, product_id: product.id, stars: 0, user_id: user.id})
	end
	defp assign_rating(socket), do: socket
end
