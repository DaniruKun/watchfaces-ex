defmodule WatchFacesWeb.FaceController do
  use WatchFacesWeb, :controller

  alias WatchFaces.Faces
  alias WatchFaces.Faces.Face

  require Logger

  def index(conn, _params) do
    faces = Faces.list_faces()
    render(conn, "index.html", faces: faces)
  end

  def new(conn, _params) do
    changeset = Faces.change_face(%Face{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"face" => face_params}) do
    pkg_file =
      if face_params["watchface_file"] do
        save_thumbnail(face_params)
        save_watchface(face_params)
      end

    case Faces.create_face(Map.merge(face_params, %{"pkg_file" => "/uploads/#{pkg_file}"})) do
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

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
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

  defp pkg_file_name(%{"author" => author, "name" => name, "watchface_file" => upload}) do
    extension = Path.extname(upload.filename)
    "#{author}-#{name}-pkg#{extension}" |> URI.encode()
  end

  defp save_watchface(%{"watchface_file" => upload} = face_params) do
    upload_file_name = pkg_file_name(face_params)

    Logger.debug("Upload file name: #{upload_file_name}")

    :ok = File.cp(upload.path, "/var/www/faces/media/#{upload_file_name}")
    upload_file_name
  end

  defp save_thumbnail(%{"watchface_file" => upload} = face_params) do
    working_dir = upload.path

    zip_opts = [
      {:cwd, to_charlist(working_dir)},
      {:file_list, ['snapshot.png']}
    ]

    # Extract thumbnail img in the temp dir
    {:ok, _filelist} = :zip.unzip(to_charlist(upload.filename), zip_opts)
    thumb_file_name = "#{face_params.author}-#{face_params.name}-thumb.png" |> URI.encode()

    # Copy and rename the extracted thumbnail to uploads folder, then delete old one
    :ok =
      File.cp(
        Path.join([working_dir, "snapshot.png"]),
        Path.join("/var/www/faces/media/", thumb_file_name),
        fn _, _ -> true end
      )
    :ok = File.rm(Path.join(working_dir, "snapshot.png"))
  end
end
