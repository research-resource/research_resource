defmodule ResearchResource.ProjectsController do
  use ResearchResource.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
