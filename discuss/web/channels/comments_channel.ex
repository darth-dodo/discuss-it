defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.Topic
  alias Discuss.Comment

  # pattern matching to join the strings in elixir
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      |> Repo.preload(:comments)

    {
      :ok,
      %{ comments: topic.comments },
      assign(socket, :topic, topic)
    }

  end

  def handle_in(name, %{"content" => content}, socket) do
    # name is the topic and subtopic of pubsub
    # message is the payload
    topic = socket.assigns.topic
    current_user_id = socket.assigns.current_user_id

    changeset = topic
    |> build_assoc(:comments, user_id: current_user_id) # Ecto. build_assoc only takes in one association and cannot be piped :|
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

    {:reply, :ok, socket}
  end

end
