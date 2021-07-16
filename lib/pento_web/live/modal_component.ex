defmodule PentoWeb.ModalComponent do
  use PentoWeb, :live_component

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, socket |> push_patch(to: socket.assigns.return_to)}
  end
end
