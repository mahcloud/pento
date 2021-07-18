defmodule PentoWeb.RatingLive.RatingComponent do
  use PentoWeb, :live_component

	def render_rating_stars(nil), do: render_rating_stars(%{stars: 0})
	def render_rating_stars(%{stars: stars}) do
		filled_stars(stars)
		|> Enum.concat(unfilled_stars(stars))
		|> Enum.join(" ")
	end

	defp filled_stars(stars) do
		List.duplicate("<i class='fas fa-star'></i>", stars)
	end

	defp unfilled_stars(stars) do
		List.duplicate("<i class='far fa-star'></i>", 5 - stars)
	end
end
