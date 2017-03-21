defmodule ResearchResource.ConsentController do
  use ResearchResource.Web, :controller

  alias ResearchResource.Redcap.Helpers

  plug :authenticate_user when action in [:new, :create]

  @redcap_api Application.get_env(:research_resource, :redcap_api)

  def new(conn, _params) do
    render(conn, "new.html", consent_questions: @redcap_api.get_instrument_fields("consent"))
  end

  # save user and consent
  def create(conn, %{"consent" => consent}) do
    # data
    user_data = Helpers.user_to_record(conn.assigns.current_user)
    consent_data = Helpers.consent_to_record(consent)
    IO.inspect consent_data
    data = Map.merge(consent_data, user_data)

    # @redcap_api.save_record(data)
    redirect(conn, to: page_path(conn, :index))
  end

  # redirect to the consent page if the form is submitted without any values (consent map is not defined)
  def create(conn, _) do
    redirect(conn, to: consent_path(conn, :new))
  end
end
