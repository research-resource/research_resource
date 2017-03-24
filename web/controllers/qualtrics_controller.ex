defmodule ResearchResource.QualtricsController do
  use ResearchResource.Web, :controller

  plug :authenticate_user when action in [:new]

  @qualtrics_api Application.get_env(:research_resource, :qualtrics_api)

  def new(conn, _) do
    survey_completed = @qualtrics_api.survey_completed?(conn.assigns.current_user.qualtrics_id)
    cond do
      survey_completed ->
        conn
        |> put_flash(:info, "The Qualtrics survey has already been completed")
        |> redirect(to: projects_path(conn, :index))
      true ->
        response = @qualtrics_api.get_survey_link(conn.assigns.current_user)
        case response do
          {:ok, survey_link} ->
            render conn, "new.html", survey_link: survey_link
          {:error, reason} ->
            render conn, "error_survey.html", error: reason
        end
    end

  end
end