defmodule WatchFacesWeb.Router do
  use WatchFacesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug WatchFacesWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WatchFacesWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create, :show]
    resources "/faces", FaceController
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    # Google Oauth
    get "/auth/google/callback", GoogleAuthController, :index
  end

  scope "/manage", WatchFacesWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/users", UserController, only: [:index, :edit, :update, :delete]
    resources "/keywords", KeywordController
    resources "/comments", CommentController
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: WatchFacesWeb.Telemetry
    end
  end
end
