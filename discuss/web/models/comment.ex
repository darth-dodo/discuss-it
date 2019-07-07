defmodule Discuss.Comment do
  use Discuss.Web, :model

  # whenever poison encoder checks this out, let it just access `content` field for JSON convertion
  @derive { Poison.Encoder, only: [:content]}

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.User
    belongs_to :topic, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
