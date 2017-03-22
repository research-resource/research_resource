defmodule ResearchResource.QualtricsController do
  use ResearchResource.Web, :controller

  @qualtrics_api Application.get_env(:research_resource, :qualtrics_api)

  def new(conn, _) do
    response = @qualtrics_api.get_survey_link(conn.assigns.current_user)
    case response do
      {:ok, survey_link} ->
        render conn, "new.html", survey_link: survey_link
      {:error, reason} ->
        render conn, "error_survey.html", error: reason
    end
  end
end