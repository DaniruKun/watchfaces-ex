defmodule WatchFacesWeb.LayoutView do
  use WatchFacesWeb, :view

  def logout_button(conn, current_user) do
    ~E"""
    <%= link "Log out",
                      to: Routes.session_path(conn, :delete, current_user),
                      method: "delete",
                      class: "btn btn-dark mx-2" %>
    """
  end
end
