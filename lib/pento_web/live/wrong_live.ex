defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    params = %{
      email: Pento.Accounts.get_user_by_session_token(session["user_token"]).email,
      message: "Guess a number.",
      score: 0,
      session_id: session["live_socket_id"],
    }
    {:ok, socket |> assign(params)}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    params = %{
      email: socket["email"],
      message: "Your guess: #{guess}. Wrong. Guess again.",
      score: socket.assigns.score - 1,
      session_id: socket["session_id"],
    }
    {:noreply, socket |> assign(params)}
  end
end
