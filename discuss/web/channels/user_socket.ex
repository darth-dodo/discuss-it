defmodule Discuss.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "comments:*", Discuss.CommentsChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, current_user} ->
        current_user_id = current_user.id
        {:ok, assign(socket, :current_user_id, current_user_id)}
      {:error, _error} ->
        :error
    end
  end

  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
