defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, %{"live_socket_id" => socket_id, "user_token" => user_token}, socket) do
    user = Pento.Accounts.get_user_by_session_token(user_token)

    params = %{
      email: user.email,
      message: "Guess a number.",
      score: 0,
      session_id: socket_id,
    }
    {:ok, socket |> assign(params)}
  end

  def handle_event("guess", %{"number" => guess}, %{assigns: %{email: email, score: score, session_id: session_id}} = socket) do
    params = %{
      email: email,
      message: "Your guess: #{guess}. Wrong. Guess again.",
      score: score - 1,
      session_id: session_id,
    }
    {:noreply, socket |> assign(params)}
  end
end
