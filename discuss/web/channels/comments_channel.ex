defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  def join(name, _params, socket) do
    IO.puts(name)
    {
      :ok,
      %{"hello" => "world"},
      socket
    }

  end

  def handle_in(name, message, socket) do
    # name is the topic and subtopic of pubsub
    # message is the payload
    IO.puts(name)
    IO.inspect(message)

    {:reply, :ok, socket}
  end

end
