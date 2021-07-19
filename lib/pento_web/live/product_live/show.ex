defmodule PentoWeb.ProductLive.Show do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias PentoWeb.Presence

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    {:ok, socket |> assign(:user_token, token)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    product = Catalog.get_product!(id)

    track_user(product, socket)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, product)}
  end

  def track_user(%{name: product_name}, %{assigns: %{live_action: :show, user_token: user_token}} = socket) do
    if connected?(socket) do
      Presence.track_user(self(), product_name, user_token)
    end
  end
  def track_user(_product, _socket), do: nil

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
