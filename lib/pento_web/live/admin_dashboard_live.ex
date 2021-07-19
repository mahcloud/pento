defmodule PentoWeb.AdminDashboardLive do
	use PentoWeb, :live_view

	alias PentoWeb.{Endpoint, SurveyResultsLive}

	@component_id "survey-results"
	@survey_results_topic "survey_results"

	def mount(_params, _session, socket) do
		if connected?(socket) do
			Endpoint.subscribe(@survey_results_topic)
		end

		{:ok,
			socket
			|> assign(:survey_results_component_id, @component_id)
		}
	end

	def handle_info(%{event: "rating_created"}, %{assigns: %{survey_results_component_id: id }} = socket) do
		send_update(SurveyResultsLive, id: id)
		{:noreply, socket}
	end
end