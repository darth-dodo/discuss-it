defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  # container for expensive operations such as database or business logic put in the init which will be execute just once
  def init(_params) do
  end

  # _params is the return value from the `init` func ^
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        # assigns the user to the a new property called current_user in our conn struct similar to Django's `request.user`
        assign(conn, :current_user, user)
        # this can be retrieved as `conn.assigns.current_user => user struct`
      true ->
        assign(conn, :current_user, nil)
    end
  end

end
