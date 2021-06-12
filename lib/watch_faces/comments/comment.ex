defmodule WatchFaces.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    belongs_to :author, WatchFaces.Accounts.User
    field :content, :string
    belongs_to :face, WatchFaces.Faces.Face

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :author, :face])
    |> validate_required([:content, :author, :face])
  end
end
