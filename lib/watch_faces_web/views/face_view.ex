defmodule WatchFacesWeb.FaceView do
  use WatchFacesWeb, :view

  def face_card(conn, face) do
    ~E"""
    <div class="col">
      <div class="card shadow-sm">
        <%= img_tag(face.thumbnail, class: "bd-placeholder-img card-img-top d-flex justify-content-center align-items-center p-3") %>

        <div class="card-body">
          <h3><%= face.name %></h3>
          <%= keywords face %>
          <div class="d-flex justify-content-between align-items-center mt-1">
            <%= link "Show", to: Routes.face_path(conn, :show, face), class: "btn btn-sm btn-outline-secondary" %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def keywords(face) do
    ~E"""
    <div class="my-2">
    <%= for keyword <- face.keywords do %>
    <span class="badge bg-dark"><%= keyword.name %></span>
    <% end %>
    </div>
    """
  end
end
