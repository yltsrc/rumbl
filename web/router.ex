defmodule Rumbl.Router do
  @moduledoc """
  """

  use Rumbl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Rumbl.Auth, repo: Rumbl.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Rumbl do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/watch/:id", WatchController, :show
    resources "/users", UserController, only: [:index, :show]
    get "/sign_up", UserController, :new
    post "/sign_up", UserController, :create
    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    get "/sign_out", SessionController, :delete
  end

  scope "/manage", Rumbl do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end
