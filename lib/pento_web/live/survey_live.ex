defmodule PentoWeb.SurveyLive do
	use PentoWeb, :live_view

	alias Pento.{Accounts, Survey}

	@impl true
	def mount(_params, %{"user_token" => token} = _session, socket) do
		{:ok,
			socket
			|> assign_user(token)
			|> assign_demographic()
		}
	end

	@impl true
	def handle_info({:created_demographic, demographic}, socket) do
		{:noreply, handle_demographic_created(socket, demographic)}
	end
	def handle_info({:updated_demographic, demographic}, socket) do
		{:noreply, handle_demographic_updated(socket, demographic)}
	end

  ###
	### PRIVATE
	###

	defp assign_demographic(%{assigns: %{current_user: user}} = socket) do
		socket
		|> assign(:demographic, Survey.get_demographic_by_user(user))
	end

	defp assign_user(socket, token) do
		socket
		|> assign_new(:current_user, fn ->
			Accounts.get_user_by_session_token(token)
		end)
	end

	defp handle_demographic_created(socket, demographic) do
		socket
		|> put_flash(:info, "Demographic created successfully")
		|> assign(:demographic, demographic)
	end

	defp handle_demographic_updated(socket, demographic) do
		socket
		|> put_flash(:info, "Demographic updated successfully")
		|> assign(:demographic, demographic)
	end
end
