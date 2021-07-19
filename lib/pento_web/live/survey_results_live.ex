defmodule PentoWeb.SurveyResultsLive do
	use PentoWeb, :live_component

	alias Pento.Catalog
	alias Contex.{BarChart, Dataset, Plot}

	def handle_event("age_group_filter", %{"age_group_filter" => age_group_filter}, socket) do
		{:noreply,
			socket
			|> assign_age_group_filter(age_group_filter)
			|> build_chart()
		}
	end

	def update(assigns, socket) do
		{:ok,
			socket
			|> assign(assigns)
			|> assign_age_group_filter()
			|> build_chart()
		}
	end

	defp assign_age_group_filter(%{assigns: %{age_group_filter: age_group_filter}} = socket) do
		assign_age_group_filter(socket, age_group_filter)
	end
	defp assign_age_group_filter(socket) do
		assign_age_group_filter(socket, "all")
	end
	defp assign_age_group_filter(socket, filter) do
		socket
		|> assign(:age_group_filter, filter)
	end

	defp assign_dataset(%{assigns: %{products: []}} = socket), do: socket
	defp assign_dataset(%{assigns: %{products: products}} = socket) do
		socket
		|> assign(:dataset, Dataset.new(products))
	end

	defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
		socket
		|> assign(:chart, BarChart.new(dataset))
	end
	defp assign_chart(socket), do: socket

	def assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
		svg = Plot.new(500, 400, chart)
		|> Plot.titles("Product Ratings", "average star ratings per product")
		|> Plot.axis_labels("products", "stars")
		|> Plot.to_svg()

		socket
		|> assign(:chart_svg, svg)
	end
	def assign_chart_svg(socket), do: socket

	defp assign_products_with_average_ratings(%{assigns: %{age_group_filter: age_group_filter}} = socket) do
		products = Catalog.list_products_with_average_ratings(%{
			age_group_filter: convert_age_filter(age_group_filter),
		})
		|> case do
		  [] -> Catalog.list_products_with_zero_ratings()
			products -> products
		end

		socket
		|> assign(:products, products)
	end

	defp build_chart(socket) do
		socket
		|> assign_products_with_average_ratings()
		|> assign_dataset()
		|> assign_chart()
		|> assign_chart_svg()
	end

	defp convert_age_filter("all"), do: nil
	defp convert_age_filter("18 and under"), do: {nil, get_birth_year(18)}
	defp convert_age_filter("18 to 25"), do: {get_birth_year(25), get_birth_year(18)}
	defp convert_age_filter("25 to 35"), do: {get_birth_year(35), get_birth_year(25)}
	defp convert_age_filter("35 and up"), do: {get_birth_year(35), nil}

	defp get_birth_year(year), do: DateTime.utc_now().year - year
end