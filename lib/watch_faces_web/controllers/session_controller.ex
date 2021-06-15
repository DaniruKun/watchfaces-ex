defmodule WatchFacesWeb.SessionController do
  use WatchFacesWeb, :controller

  def new(conn, _) do
    oauth_google_url = ElixirAuthGoogle.generate_oauth_url(conn)
    render(conn, "new.html", oauth_google_url: oauth_google_url)
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case WatchFaces.Accounts.authenticate_by_username_and_pass(username, pass) do
      {:ok, user} ->
        conn
        |> WatchFacesWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back, #{username}")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> WatchFacesWeb.Auth.logout()
    |> put_flash(:info, "Logged out succesfully.")
    |> redirect(to: Routes.face_path(conn, :index))
  end
end
