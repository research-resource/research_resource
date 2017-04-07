defmodule ResearchResource.ProjectsController do
  use ResearchResource.Web, :controller
  alias ResearchResource.Redcap.RedcapHelpers
  @redcap_api Application.get_env(:research_resource, :redcap_api)
  @qualtrics_api Application.get_env(:research_resource, :qualtrics_api)
  @qualtrics_survey_id Application.get_env(:research_resource, :qualtrics_survey_id)

  def index(conn, _params) do
    projects = @redcap_api.get_projects()
    if conn.assigns.current_user do
      user_data = @redcap_api.get_user_data(conn.assigns.current_user.ttrrid)
      mine_other = %{
        mine: Enum.filter(projects, fn(project) -> complete?(user_data[project[:id_project] <> "_complete"]) end),
        other: Enum.filter(projects, fn(project) -> !complete?(user_data[project[:id_project] <> "_complete"]) end)
      }
      render conn, "index.html", projects: mine_other
    else
      current_archived = %{
        current: Enum.filter(projects, fn(project) -> project[:status] != "archived" end),
        archived: Enum.filter(projects, fn(project) -> project[:status] == "archived" end)
      }
      render conn, "index.html", projects: current_archived
    end
  end

  def show(conn, %{"id" => id_project}) do
    project = Map.merge(@redcap_api.get_project(id_project), %{applied: false})
    if (conn.assigns.current_user) do
      user_data = @redcap_api.get_user_data(conn.assigns.current_user.ttrrid)
      applied = %{applied: complete?(user_data[id_project <> "_complete"])}
      project = Map.merge(project, applied)
      consent_answers = user_data
      registration_complete = registration_complete?(conn.assigns.current_user)
      render conn, "show.html", project: project, consent_answers: consent_answers, registration_complete: registration_complete
    else
      render conn, "show.html", project: project
    end
  end

  defp registration_complete?(user) do
    if user.ttrr_consent do
      {:ok, qualtics_contact} = @qualtrics_api.get_contact(user.qualtrics_id)
      response_survey = Enum.find(qualtics_contact["responseHistory"], &(&1["surveyId"] == @qualtrics_survey_id))
      response_survey["finishedSurvey"]
    else
      false
    end
  end

  def create(conn, %{"consent" => consent}) do
    user_data = RedcapHelpers.user_to_record(conn.assigns.current_user)
    complete_field = consent["id_project"] <> "_complete"
    consent
    |> Enum.filter(fn {key, _} -> String.starts_with?(key, "consent") end)
    |> Enum.map(fn {key, val} -> {Regex.replace(~r/_[yn]\b/, key, ""), val} end)
    |> RedcapHelpers.consent_to_record
    |> Map.merge(user_data)
    |> Map.merge(%{String.to_atom(complete_field) => 2})
    |> @redcap_api.save_record

    send_project_email(conn.assigns.current_user, consent["id_project"])

    conn
    |> put_flash(:error, "Thanks for participating to the project!")
    |> redirect(to: projects_path(conn, :index))
  end

  defp complete?(value) do
    case value do
      "2" -> true
      _ -> false
    end
  end

  @contact_email Application.get_env(:research_resource, :contact_email)
  defp send_project_email(user, project) do
    subject = "New project application"
    message = """
    Hello,
    #{user.first_name} - #{user.ttrrid} has applied for the following project: #{project}
    """
    ResearchResource.Email.send_email(@contact_email, subject, message)
    |> ResearchResource.Mailer.deliver_now()
  end

end
