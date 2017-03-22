defmodule ResearchResource.Qualtrics.HTTPClient do
  @qualtrics_token Application.get_env(:research_resource, :qualtrics_token)
  @qualtrics_mailinglist_id Application.get_env(:research_resource, :qualtrics_mailinglist_id)
  @qualtrics_survey_id Application.get_env(:research_resource, :qualtrics_survey_id)
  @qualtrics_distribution_id Application.get_env(:research_resource, :qualtrics_distribution_id)
  @qualtrics_headers [{"X-API-TOKEN", @qualtrics_token}, {"Content-Type", "application/json"}]

  def create_contact(user) do
    {:ok, payload} = Poison.encode(user)
    url = "https://eu.qualtrics.com/API/v3/mailinglists/#{@qualtrics_mailinglist_id}/contacts"
    HTTPoison.post(url, payload, @qualtrics_headers)
  end

  def get_survey_link(user) do
    url = "https://eu.qualtrics.com/API/v3/distributions/#{@qualtrics_distribution_id}/links?surveyId=#{@qualtrics_survey_id}"
    get_distribution_link(url, user.ttrrid)
  end

  defp get_distribution_link(url, external_data_reference) do
    {:ok, res} = HTTPoison.get(url, @qualtrics_headers)
    {:ok, data} = Poison.Parser.parse(res.body)
    next_page = data["result"]["nextPage"]
    elements = data["result"]["elements"]
    distribution_link = List.first(Enum.filter(elements, fn(elt) -> elt["externalDataReference"] == external_data_reference end))
    cond do
      distribution_link ->
        {:ok, distribution_link["link"]}
      next_page ->
        get_distribution_link(next_page, external_data_reference)
      true ->
        {:error, "no Qualtrics questionnaire found"}
    end
  end

end