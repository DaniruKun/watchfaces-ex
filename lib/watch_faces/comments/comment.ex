defmodule WatchFaces.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :author, :integer
    field :content, :string
    field :face, :integer

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :author, :face])
    |> validate_required([:content, :author, :face])
  end
end
