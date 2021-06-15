defmodule WatchFacesWeb.FaceController do
  use WatchFacesWeb, :controller

  alias WatchFaces.Faces
  alias WatchFaces.Faces.Face

  require Logger

  @media_folder_path "/var/www/faces/media/"

  def index(conn, params) do
    faces =
      case params do
        %{"q" => ""} ->
          Faces.list_faces()

        %{"q" => query} ->
          Faces.search_face(query)

        _ ->
          Faces.list_faces()
      end

    render(conn, "index.html", faces: faces)
  end

  def new(conn, _params) do
    changeset = Faces.change_face(%Face{})
    keywords = fetch_keywords()
    render(conn, "new.html", changeset: changeset, keywords: keywords)
  end

  def create(conn, %{"face" => face_params}) do
    if face_params["watchface_file"] do
      with {:ok, thumbnail_file_name} <- save_thumbnail(face_params),
           {:ok, pkg_file_name} <- save_watchface(face_params) do
        file_params = %{
          "pkg_file" => "/uploads/#{pkg_file_name}",
          "thumbnail" => "/uploads/#{thumbnail_file_name}"
        }

        case Faces.create_face(Map.merge(face_params, file_params)) do
          {:ok, face} ->
            conn
            |> put_flash(:info, "Face created successfully.")
            |> redirect(to: Routes.face_path(conn, :show, face))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      end
    end
  end

  def show(conn, %{"id" => id}) do
    face = Faces.get_face!(id)
    render(conn, "show.html", face: face, keywords: [])
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    face = Faces.get_face!(id)
    changeset = Faces.change_face(face)
    keywords = fetch_keywords()
    render(conn, "edit.html", face: face, changeset: changeset, keywords: keywords)
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

  defp pkg_file_name(%{"user_id" => author, "name" => name, "watchface_file" => upload}) do
    extension = Path.extname(upload.filename)
    "#{author}-#{name}-pkg#{extension}" |> String.replace(" ", "") |> URI.encode()
  end

  defp save_watchface(%{"watchface_file" => upload} = face_params) do
    upload_file_name = pkg_file_name(face_params)

    Logger.debug("Upload file name: #{upload_file_name}")

    :ok = File.cp(upload.path, @media_folder_path <> upload_file_name)
    {:ok, upload_file_name}
  end

  defp save_thumbnail(%{"watchface_file" => upload, "user_id" => author, "name" => face_name}) do
    workdir = Path.dirname(upload.path)

    zip_opts = [
      {:cwd, to_charlist(workdir)},
      {:file_list, ['snapshot.png']}
    ]

    # Extract thumbnail img in the temp dir
    {:ok, _filelist} = :zip.unzip(to_charlist(upload.path), zip_opts)

    thumb_file_name =
      "#{author}-#{face_name}-thumb.png" |> String.replace(" ", "") |> URI.encode()

    # Copy and rename the extracted thumbnail to uploads folder, then delete old one
    :ok =
      File.cp(
        Path.join([workdir, "snapshot.png"]),
        Path.join(@media_folder_path, thumb_file_name),
        fn _, _ -> true end
      )

    :ok = File.rm(Path.join(workdir, "snapshot.png"))
    {:ok, thumb_file_name}
  end

  defp save_thumbnail(_face_params), do: {:error, "missing required params"}

  defp fetch_keywords() do
    WatchFaces.Keywords.list_keywords() |> Enum.map(&{&1.name, &1.name})
  end
end
