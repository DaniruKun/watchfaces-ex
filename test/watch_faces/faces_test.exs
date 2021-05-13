defmodule WatchFaces.FacesTest do
  use WatchFaces.DataCase

  alias WatchFaces.Faces

  describe "faces" do
    alias WatchFaces.Faces.Face

    @valid_attrs %{author: 42, keywords: [], name: "some name"}
    @update_attrs %{author: 43, keywords: [], name: "some updated name"}
    @invalid_attrs %{author: nil, keywords: nil, name: nil}

    def face_fixture(attrs \\ %{}) do
      {:ok, face} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Faces.create_face()

      face
    end

    test "list_faces/0 returns all faces" do
      face = face_fixture()
      assert Faces.list_faces() == [face]
    end

    test "get_face!/1 returns the face with given id" do
      face = face_fixture()
      assert Faces.get_face!(face.id) == face
    end

    test "create_face/1 with valid data creates a face" do
      assert {:ok, %Face{} = face} = Faces.create_face(@valid_attrs)
      assert face.author == 42
      assert face.keywords == []
      assert face.name == "some name"
    end

    test "create_face/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Faces.create_face(@invalid_attrs)
    end

    test "update_face/2 with valid data updates the face" do
      face = face_fixture()
      assert {:ok, %Face{} = face} = Faces.update_face(face, @update_attrs)
      assert face.author == 43
      assert face.keywords == []
      assert face.name == "some updated name"
    end

    test "update_face/2 with invalid data returns error changeset" do
      face = face_fixture()
      assert {:error, %Ecto.Changeset{}} = Faces.update_face(face, @invalid_attrs)
      assert face == Faces.get_face!(face.id)
    end

    test "delete_face/1 deletes the face" do
      face = face_fixture()
      assert {:ok, %Face{}} = Faces.delete_face(face)
      assert_raise Ecto.NoResultsError, fn -> Faces.get_face!(face.id) end
    end

    test "change_face/1 returns a face changeset" do
      face = face_fixture()
      assert %Ecto.Changeset{} = Faces.change_face(face)
    end
  end
end
