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
end