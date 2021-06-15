defmodule WatchFacesWeb.GoogleAuthController do
  use WatchFacesWeb, :controller

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
    IO.inspect(profile, label: "Google profile: \n")

    Plug.Conn.assign(conn, :profile, profile)
  end
end

# Google profile:
# : %{
#   email: "thedanpetrov@gmail.com",
#   email_verified: true,
#   family_name: "Petrov",
#   given_name: "Dan",
#   locale: "en",
#   name: "Dan Petrov",
#   picture: "https://lh3.googleusercontent.com/a-/AOh14GiPApcbILbz91lf8Y50LCICZa3LMNM4zWmBLo2sEg=s96-c",
#   sub: "112429832541706179135"
# }
