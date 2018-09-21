defmodule Ibento.Web.Router do
  use Ibento.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope("/core") do
    forward("/", Ibento.GraphQL.Core.Router)
  end

  scope("/edge") do
    forward("/", Ibento.GraphQL.Edge.Router)
  end

  scope "/", Ibento.Web do
    # Use the default browser stack
    pipe_through :browser

    get "/", PageController, :index

    get "/events", EventController, :list_events
    get "/events/create", EventController, :create_event
  end

  # Other scopes may use custom stacks.
  # scope "/api", Ibento.Web do
  #   pipe_through :api
  # end
end
