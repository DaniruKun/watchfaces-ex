defmodule WatchFacesWeb.FaceController do
  use WatchFacesWeb, :controller

  alias WatchFaces.Faces
  alias WatchFaces.Faces.Face

  def index(conn, _params) do
    faces = Faces.list_faces()
    render(conn, "index.html", faces: faces)
  end

  def new(conn, _params) do
    changeset = Faces.change_face(%Face{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"face" => face_params}) do
    case Faces.create_face(face_params) do
      {:ok, face} ->
        conn
        |> put_flash(:info, "Face created successfully.")
        |> redirect(to: Routes.face_path(conn, :show, face))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    face = Faces.get_face!(id)
    render(conn, "show.html", face: face)
  end

  def edit(conn, %{"id" => id}) do
    face = Faces.get_face!(id)
    changeset = Faces.change_face(face)
    render(conn, "edit.html", face: face, changeset: changeset)
  end

  def update(conn, %{"id" => id, "face" => face_params}) do
    face = Faces.get_face!(id)

    case Faces.update_face(face, face_params) do
      {:ok, face} ->
        conn
        |> put_flash(:info, "Face updated successfully.")
        |> redirect(to: Routes.face_path(conn, :show, face))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", face: face, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    face = Faces.get_face!(id)
    {:ok, _face} = Faces.delete_face(face)

    conn
    |> put_flash(:info, "Face deleted successfully.")
    |> redirect(to: Routes.face_path(conn, :index))
  end
end
