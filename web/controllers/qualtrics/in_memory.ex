defmodule ResearchResource.Qualtrics.InMemory do
  def create_contact(_user) do
    {:ok, "Qualtrics API response"}
  end

  def get_survey_link(user) do
    case user.email do
      "me@test.com" ->
        {:ok, "https://duckduckgo.com/"}
      "not@found.com" ->
        {:error, "no Qualtrics questionnaire found"}
    end
  end

  def survey_completed?(contact_id) do
    case contact_id do
      "1" -> true
      "0" -> false
    end
  end

  def get_contact(_contact_id) do
    {:ok, %{
      "email" => "email@email.com",
      "emailHistory" => [],
      "embeddedData" => nil,
      "externalDataReference" => "TTRRID",
      "firstName" => "Bob",
      "id" => "idqualtrics",
      "language" => "en-gb",
      "lastName" => "Bob",
      "responseHistory" => [],
      "unsubscribed" => false}}
  end

end