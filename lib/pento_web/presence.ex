defmodule PentoWeb.Presence do
	use Phoenix.Presence, otp_app: :pento, pubsub_server: Pento.PubSub

  alias Pento.Accounts

	@user_activity_topic "user_activity"

	defp extract_product_with_users({product_name, %{metas: metas}}) do
		{product_name, users_from_metas_list(metas)}
	end

	def list_products_and_users do
		list(@user_activity_topic)
		|> Enum.map(&extract_product_with_users/1)
	end

	def track_user(pid, product_name, token) do
		%{email: email} = Accounts.get_user_by_session_token(token)

		track(
			pid,
			@user_activity_topic,
			product_name,
			%{users: [%{email: email}]}
		)
	end

	defp users_from_metas_list(metas_list) do
		Enum.map(metas_list, &users_from_meta_map/1)
		|> List.flatten()
		|> Enum.uniq()
	end
	def users_from_meta_map(meta_map) do
		get_in(meta_map, [:users])
	end
end