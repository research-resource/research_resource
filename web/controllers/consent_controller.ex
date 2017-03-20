defmodule ResearchResource.ConsentController do
  use ResearchResource.Web, :controller

  alias ResearchResource.Redcap

  plug :authenticate_user when action in [:index]

  def index(conn, _params) do
    render(conn, "index.html", consent_questions: Redcap.get_instrument_fields("consent"))
  end
end
