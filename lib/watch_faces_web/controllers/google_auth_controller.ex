defmodule WatchFacesWeb.GoogleAuthController do
  use WatchFacesWeb, :controller

  alias WatchFaces.Accounts

  require Logger

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    with {:ok, token} <- ElixirAuthGoogle.get_token(code, conn),
         {:ok, profile} <- ElixirAuthGoogle.get_user_profile(token.access_token),
         google_email <- profile.email do
      case Accounts.get_user_by(email: google_email) do
        nil ->
          Logger.info("Registering new user from Google account with email: " <> google_email)
          case Accounts.create_user_from_google(profile) do
            {:ok, user} ->
              conn
              |> WatchFacesWeb.Auth.login(user)
              |> put_flash(:info, "Registered with Google account succesfully")
              |> redirect(to: Routes.page_path(conn, :index))

            {:error, _changeset} ->
              conn
              |> put_flash(:error, "Failed to register with Google")
              |> redirect(to: Routes.user_path(conn, :new))
          end

        user ->
          Logger.debug("Logging in existing Google user with email: " <> google_email)
          conn
          |> WatchFacesWeb.Auth.login(user)
          |> put_flash(:info, "Welcome back")
          |> redirect(to: Routes.page_path(conn, :index))
      end
    end
  end
end
