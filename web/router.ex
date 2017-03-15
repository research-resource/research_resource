defmodule ResearchResource.Router do
  use ResearchResource.Web, :router

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

  scope "/", ResearchResource do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/about", AboutController, :index
    get "/projects", ProjectsController, :index
    get "/who", WhoWeAreController, :index
    get "/faqs", FaqsController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ResearchResource do
  #   pipe_through :api
  # end
end
