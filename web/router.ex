defmodule ResearchResource.Router do
  use ResearchResource.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ResearchResource.Auth, repo: ResearchResource.Repo
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", ResearchResource do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/about", AboutController, :index
    get "/projects", ProjectsController, :index
    get "/who", WhoWeAreController, :index
    get "/faqs", FaqsController, :index
    get "/account", AccountController, :index

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/consent", ConsentController, only: [:new, :create]
    resources "/qualtrics", QualtricsController, only: [:new]
  end
end
