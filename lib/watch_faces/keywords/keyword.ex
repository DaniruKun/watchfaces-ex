defmodule WatchFaces.Keywords.Keyword do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords" do
    field :name, :string
    many_to_many :face, WatchFaces.Faces.Face, join_through: "faces_keywords", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
