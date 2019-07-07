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
    IO.puts(name)
    IO.inspect(content)

    topic = socket.assigns.topic

    IO.inspect(topic)

    changeset = topic
    |> build_assoc(:comments)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

    {:reply, :ok, socket}
  end

end
