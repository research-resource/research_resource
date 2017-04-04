defmodule ResearchResource.ProjectsController do
  use ResearchResource.Web, :controller
  @redcap_api Application.get_env(:research_resource, :redcap_api)

  def index(conn, _params) do
    projects = @redcap_api.get_projects()
    render conn, "index.html", projects: projects
  end
end
