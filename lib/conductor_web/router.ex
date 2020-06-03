defmodule ConductorWeb.Router do
  use ConductorWeb, :router
  import ConductorWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :put_layout, {ConductorWeb.LayoutView, "admin.html"}
  end

  scope "/auth", ConductorWeb do
    pipe_through :browser

    get "/login", AuthController, :login
    get "/logout", AuthController, :logout

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/admin", ConductorWeb.Admin, as: :admin do
    pipe_through [:browser, :require_user, :admin]

    get "/", HomeController, :index
  end

  scope "/", ConductorWeb do
    pipe_through :browser

    get "/", RedirectController, :index
    get "/:code", RedirectController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ConductorWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ConductorWeb.Telemetry
    end
  end
end
