defmodule ResearchResource.AboutController do
  use ResearchResource.Web, :controller

  plug :authenticate_user when action in [:about]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def about(conn, _params) do
    render conn, "about.html"
  end
end
