defmodule SlivceWeb.Router do
  use SlivceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SlivceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SlivceWeb do
    pipe_through :browser

    live "/", GameLive, :index

    live "/words", WordLive.Index, :index
    live "/words/new", WordLive.Index, :new
    live "/words/:id/edit", WordLive.Index, :edit

    live "/words/:id", WordLive.Show, :show
    live "/words/:id/show/edit", WordLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", SlivceWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:slivce, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SlivceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
