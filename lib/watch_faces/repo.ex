defmodule WatchFaces.Repo do
  use Ecto.Repo,
    otp_app: :watch_faces,
    adapter: Ecto.Adapters.Postgres
end
