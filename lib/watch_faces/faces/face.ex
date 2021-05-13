defmodule WatchFaces.Faces.Face do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faces" do
    field :author, :integer
    field :keywords, {:array, :string}
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(face, attrs) do
    face
    |> cast(attrs, [:name, :author, :keywords])
    |> validate_required([:name, :author, :keywords])
  end
end
