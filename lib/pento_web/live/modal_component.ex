defmodule PentoWeb.ModalComponent do
  use PentoWeb, :live_component

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
