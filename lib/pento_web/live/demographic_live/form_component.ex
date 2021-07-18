defmodule PentoWeb.DemographicLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    socket = socket
    |> assign(assigns)
    |> assign_demographic()
    |> assign_changeset()

    {:ok, socket}
  end

  defp assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    socket
    |> assign(:changeset, Survey.change_demographic(demographic))
  end

  defp assign_demographic(%{assigns: %{user: user}} = socket) do
    socket
    |> assign(:demographic, %Demographic{user_id: user.id})
  end
end
