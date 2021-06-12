defmodule WatchFaces.Faces.Face do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faces" do
    field :name, :string, null: false
    field :pkg_file, :string, null: false
    field :thumbnail, :string
    field :keywords, {:array, :string}
    belongs_to :user, WatchFaces.Accounts.User
    #many_to_many :keywords, WatchFaces.Keywords.Keyword, join_through: "faces_keywords"

    timestamps()
  end

  @doc false
  def changeset(face, attrs) do
    face
    |> cast(attrs, [:name, :pkg_file, :thumbnail])
    |> validate_required([:name, :pkg_file])
  end
end
