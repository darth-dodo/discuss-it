defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    struct = %Topic{}
    params = %{}
    changeset = Topic.changeset(struct, params)
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.current_user
    |> build_assoc(:topics)
    |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created!")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do

    # get the topic from the Repo
    topic = Repo.get(Topic, topic_id)

    # convert it into a structure using the changeset method
    changeset = Topic.changeset(topic)

    # push this out to the template/form helper
    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"topic" => topic, "id" => topic_id}) do

    # first arg to the changeset is a struct which repr something that sits in the db and the second one is the new attrs which is the topic data from the form
    # old_topic = Repo.get(Topic, topic_id)
    # changeset = Topic.changeset(old_topic, topic)

    old_topic = Repo.get(Topic, topic_id)
    changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated!")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end

  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted!")
    |> redirect(to: topic_path(conn, :index))
  end

end
