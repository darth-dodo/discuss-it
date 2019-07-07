defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.Topic

  # pattern matching to join the strings in elixir
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)

    {
      :ok,
      %{ "topic_id" => topic.id},
      socket
    }

  end

  def handle_in(name, %{"content" => content}, socket) do
    # name is the topic and subtopic of pubsub
    # message is the payload
    IO.puts(name)
    IO.inspect(content)

    {:reply, :ok, socket}
  end

end
