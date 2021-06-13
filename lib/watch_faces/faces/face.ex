defmodule WatchFaces.Faces.Face do
  @moduledoc """
  Face schema and changeset definitions module.

  A face typically consists of a name, keywords, an author, a watchface file path and a thumbnail image.
  """
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
    |> WatchFaces.Repo.preload(:user)
    |> cast(attrs, [:name, :pkg_file, :thumbnail, :keywords, :user_id])
    |> validate_required([:name, :pkg_file])
  end

  def insert_changeset(%{"user_id" => user_id} = attrs) do
    user = WatchFaces.Accounts.get_user!(user_id)

    Ecto.build_assoc(user, :faces, attrs)
    |> cast(attrs, [:name, :pkg_file, :thumbnail, :keywords, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end
end
