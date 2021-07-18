defmodule PentoWeb.DemographicLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Demographic

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    {:noreply,
      socket
      |> save_demographic(demographic_params)
    }
  end

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> assign_changeset()}
  end

  ###
  ### PRIVATE
  ###

  def assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end

  defp assign_demographic(%{assigns: %{demographic: nil, user: user}} = socket) do
    socket
    |> assign(:demographic, %Demographic{user_id: user.id})
  end
  defp assign_demographic(%{assigns: %{demographic: _demographic}} = socket), do: socket

  defp save_demographic(%{assigns: %{demographic: %{id: nil}}} = socket, params) do
    case Survey.create_demographic(params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket
      {:error, %Ecto.Changeset{} = changeset} ->
        socket |> assign(changeset: changeset)
    end
  end
  defp save_demographic(%{assigns: %{demographic: original_demographic}} = socket, params) do
    case Survey.update_demographic(original_demographic, params) do
      {:ok, demographic} ->
        send(self(), {:updated_demographic, demographic})
        socket
      {:error, %Ecto.Changeset{} = changeset} ->
        socket |> assign(changeset: changeset)
    end
  end
end
