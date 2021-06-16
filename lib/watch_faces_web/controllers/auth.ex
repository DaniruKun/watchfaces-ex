defmodule WatchFacesWeb.Auth do
  @moduledoc """
  WatchFaces auth module plug.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && WatchFaces.Accounts.get_user!(user_id)

    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  import Phoenix.Controller
  alias WatchFacesWeb.Router.Helpers, as: Routes

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  def authenticate_admin(conn, _opts) do
    case conn.assigns.current_user.role do
      "admin" ->
        conn

      _ ->
        if "faces" in conn.path_info && "edit" in conn.path_info && owns_face(conn) do
          conn
        else
          conn
          |> put_flash(:error, "You must have the role: admin to access that page.")
          |> redirect(to: Routes.page_path(conn, :index))
          |> halt()
        end
    end
  end

  defp owns_face(conn) do
    %{"id" => face_id} = conn.params

    case conn.assigns.current_user.faces do
      [] -> false
      user_faces -> user_faces |> Enum.any?(fn face -> face.id == String.to_integer(face_id) end)
    end
  end
end
