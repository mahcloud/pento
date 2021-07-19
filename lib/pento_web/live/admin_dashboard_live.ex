defmodule PentoWeb.AdminDashboardLive do
	use PentoWeb, :live_view

	alias PentoWeb.{Endpoint, SurveyResultsLive}

	@survey_results_component_id "survey-results"
	@survey_results_topic "survey_results"
  @user_activity_component_id "user-activity"
	@user_activity_topic "user_activity"

	def mount(_params, _session, socket) do
		if connected?(socket) do
			Endpoint.subscribe(@survey_results_topic)
			Endpoint.subscribe(@user_activity_topic)
		end

		{:ok,
			socket
			|> assign(:survey_results_component_id, @survey_results_component_id)
			|> assign(:user_activity_component_id, @user_activity_component_id)
		}
	end

	def handle_info(%{event: "rating_created"}, %{assigns: %{survey_results_component_id: id }} = socket) do
		send_update(SurveyResultsLive, id: id)
		{:noreply, socket}
	end
	def handle_info(%{event: "presence_diff"}, socket) do
		send_update(UserActivityLive, id: socket.assigns.user_activity_component_id)
		{:noreply, socket}
	end
end