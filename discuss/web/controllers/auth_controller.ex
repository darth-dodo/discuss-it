defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  # assigns property is used to stash data between different parts of our app
  def callback(%{assigns: %{ueberauth_auth: auth }} = conn, params) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: get_provider(params)
    }

    changeset = User.changeset(%User{}, user_params)
    sign_in(conn, changeset)
  end

  # private methods
  defp sign_in(conn, changeset) do
    case upsert_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error while signing in!")
        |> redirect(to: topic_path(conn, :index))
    end

  end

  defp get_provider(params) do
    params["provider"]
  end

  defp upsert_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

end
