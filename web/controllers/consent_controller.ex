defmodule ResearchResource.ConsentController do
  use ResearchResource.Web, :controller

  alias ResearchResource.Redcap

  plug :authenticate_user when action in [:new, :create]

  def new(conn, _params) do
    render(conn, "new.html", consent_questions: Redcap.get_instrument_fields("consent"))
  end

  def create(conn, %{"consent" => consent}) do
    user_data = Redcap.user_to_record(conn.assigns.current_user)
    consent_data = Redcap.consent_to_record(consent)
    data = Map.merge(consent_data, user_data)
    Redcap.save_record(data)
    redirect(conn, to: page_path(conn, :index))
  end

end
