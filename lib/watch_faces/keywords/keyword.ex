defmodule WatchFaces.Keywords.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
