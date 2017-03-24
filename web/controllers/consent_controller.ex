defmodule ResearchResource.ConsentController do
  use ResearchResource.Web, :controller

  alias ResearchResource.{Redcap.RedcapHelpers, Qualtrics.QualtricsHelpers, User}

  plug :authenticate_user when action in [:new, :create]

  @redcap_api Application.get_env(:research_resource, :redcap_api)
  @qualtrics_api Application.get_env(:research_resource, :qualtrics_api)

  def new(conn, _params) do
    render(conn, "new.html", consent_questions: @redcap_api.get_instrument_fields("consent"))
  end

  # save user and consent
  def create(conn, %{"consent" => consent}) do
    user_data = RedcapHelpers.user_to_record(conn.assigns.current_user)
    consent_data = RedcapHelpers.consent_to_record(consent)
    data = Map.merge(consent_data, user_data)
    @redcap_api.save_record(data)

    contact_qualtrics = QualtricsHelpers.user_to_qualtrics_contact(conn.assigns.current_user)
    case @qualtrics_api.create_contact(contact_qualtrics) do
      {:ok, id} ->
        # update user model and postgres data with qualtrics id
        changeset = User.changeset(conn.assigns.current_user, %{"qualtrics_id" => id} )
        case Repo.update(changeset) do
          {:ok, user} ->
            conn
            |> assign(:current_user, user)
            |> redirect(to: qualtrics_path(conn, :new))
        end
    end

  end

  # redirect to the consent page if the form is submitted without any values (consent map is not defined)
  def create(conn, _) do
    redirect(conn, to: consent_path(conn, :new))
  end
end
