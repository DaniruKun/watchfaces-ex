defmodule WatchFaces.Faces do
  @moduledoc """
  The Faces context.
  """

  import Ecto.Query, warn: false
  alias WatchFaces.Repo

  alias WatchFaces.Faces.Face

  @doc """
  Returns the list of faces.

  ## Examples

      iex> list_faces()
      [%Face{}, ...]

  """
  def list_faces do
    Repo.all(Face)
    |> Repo.preload([:keywords])
  end

  @doc """
  Gets a single face.

  Raises `Ecto.NoResultsError` if the Face does not exist.

  ## Examples

      iex> get_face!(123)
      %Face{}

      iex> get_face!(456)
      ** (Ecto.NoResultsError)

  """
  def get_face!(id), do: Repo.get!(Face, id) |> Repo.preload([:user, :keywords])

  @doc """
  Creates a face.

  ## Examples

      iex> create_face(%{field: value})
      {:ok, %Face{}}

      iex> create_face(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_face(attrs \\ %{}) do
    Face.insert_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a face.

  ## Examples

      iex> update_face(face, %{field: new_value})
      {:ok, %Face{}}

      iex> update_face(face, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_face(%Face{} = face, attrs) do
    face
    |> Face.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a face.

  ## Examples

      iex> delete_face(face)
      {:ok, %Face{}}

      iex> delete_face(face)
      {:error, %Ecto.Changeset{}}

  """
  def delete_face(%Face{} = face) do
    face
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking face changes.

  ## Examples

      iex> change_face(face)
      %Ecto.Changeset{data: %Face{}}

  """
  def change_face(%Face{} = face, attrs \\ %{}) do
    Face.changeset(face, attrs)
  end
end
