# return a conn object from the module plug for continuing the execution
defmodule Discuss.Plugs.RequireAuth do

  import Plug.Conn
  import Phoenix.Controller
  alias Discuss.Router.Helpers

  # we are required to def this function even if we don't need it
  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in!")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt() # controller handlers are assumed as the last step, in case of Plug, Phoenix assumes that it will have to send the next plug in the row. Explicitly break the pipeline using `halt`
    end
  end

end
