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
    # /about/consent is used to display the about page after a user signup, see #106
    get "/about/consent", AboutController, :about
    get "/consent/view", ConsentController, :view
    get "/who", WhoWeAreController, :index
    get "/faqs", FaqsController, :index

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/consent", ConsentController, only: [:new, :create]
    resources "/qualtrics", QualtricsController, only: [:new]
    resources "/projects", ProjectsController, only: [:index, :show]
    resources "/account", AccountController, only: [:index, :update]
    resources "/change_password", ChangePasswordController, only: [:index, :update]
    resources "/contact", ContactController, only: [:index, :create]
  end
end
