defmodule WatchFacesWeb.PageController do
  use WatchFacesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
