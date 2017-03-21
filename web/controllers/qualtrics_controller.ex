defmodule ResearchResource.QualtricsController do
  use ResearchResource.Web, :controller

  def new(conn, _) do
    # render the Qualtrics questionnaire in an iframe
    render conn, "new.html"
  end
end