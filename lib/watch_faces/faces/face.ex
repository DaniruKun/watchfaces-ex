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
    belongs_to :user, WatchFaces.Accounts.User

    many_to_many :keywords, WatchFaces.Keywords.Keyword,
      join_through: "faces_keywords",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(face, attrs) do
    face
    |> WatchFaces.Repo.preload([:user, :keywords])
    |> cast(attrs, [:name, :pkg_file, :thumbnail])
    |> keyword_changeset(attrs)
    |> validate_required([:name, :pkg_file])
  end

  def insert_changeset(%{"user_id" => user_id} = attrs) do
    user = WatchFaces.Accounts.get_user!(user_id)

    user
    |> Ecto.build_assoc(:faces, attrs)
    |> cast(attrs, [:name, :pkg_file, :thumbnail])
    |> validate_required(:name)
    |> keyword_changeset(attrs)
    |> put_assoc(:user, user)
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end

  defp keyword_changeset(changeset, attrs) do
    keywords =
      WatchFaces.Keywords.list_keywords()
      |> Enum.filter(&(attrs["keywords"] && &1.name in attrs["keywords"]))

    put_assoc(changeset, :keywords, keywords)
  end
end
