defmodule ResearchResource.ConsentController do
  use ResearchResource.Web, :controller

  alias ResearchResource.Redcap

  plug :authenticate_user when action in [:new, :create]

  def new(conn, _params) do
    render(conn, "new.html", consent_questions: Redcap.get_instrument_fields("consent"))
  end

  def create(conn, %{"consent" => consent}) do
    user_data = Redcap.user_to_record(conn.assigns.current_user)
    IO.inspect user_data
    IO.puts "****************************"
    # data = Map.merge(consent, user_data)
    Redcap.save_record(user_data)
    # get user
    render(conn, "new.html", consent_questions: Redcap.get_instrument_fields("consent"))
  #   %{"consent_1" => "Yes", "consent_2" => "No", "consent_3" => "Yes",
  # "consent_4" => "Yes", "consent_5" => "Yes", "consent_6" => "Yes",
  # "consent_7" => "Yes"}


  end

end
