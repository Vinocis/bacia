defmodule BaciaWeb.Router do
  use BaciaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BaciaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_auth do
    plug BaciaWeb.Plugs.Guardian.AuthAccessPipeline
  end

  scope "/", BaciaWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/customer", BaciaWeb.Bank do
    pipe_through :api

    post "/", CustomerController, :create
    post "/sign_in", CustomerController, :sign_in

    scope "/" do
      pipe_through :jwt_auth

      get "/balance", CustomerController, :show_balance
      patch "/deposit", CustomerController, :deposit
      post "/transaction", TransactionController, :create
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BaciaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bacia, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BaciaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
