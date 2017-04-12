defmodule ResearchResource.Qualtrics.HTTPClient do
  alias Poison.Parser

  @qualtrics_token Application.get_env(:research_resource, :qualtrics_token)
  @qualtrics_mailinglist_id Application.get_env(:research_resource, :qualtrics_mailinglist_id)
  @qualtrics_survey_id Application.get_env(:research_resource, :qualtrics_survey_id)
  @qualtrics_distribution_id Application.get_env(:research_resource, :qualtrics_distribution_id)
  @qualtrics_headers [{"X-API-TOKEN", @qualtrics_token}, {"Content-Type", "application/json"}]

  @qualtrics_url "https://eu.qualtrics.com/API/v3"
  def create_contact(user) do
    {:ok, payload} = Poison.encode(user)
    url = "#{@qualtrics_url}/mailinglists/#{@qualtrics_mailinglist_id}/contacts"
    case HTTPoison.post(url, payload, @qualtrics_headers) do
      {:ok, res} ->
        {:ok, data} = Parser.parse(res.body)
        {:ok, data["result"]["id"]}
      {:error, _res} ->
        {:error, "Error create Qualtrics contact"}
    end
  end

  def get_survey_link(user) do
    url = "#{@qualtrics_url}/distributions/#{@qualtrics_distribution_id}/links?surveyId=#{@qualtrics_survey_id}"
    get_distribution_link(url, user.ttrrid)
  end

  def get_contact(contact_id) do
    url = "#{@qualtrics_url}/mailinglists/#{@qualtrics_mailinglist_id}/contacts/#{contact_id}"
    case HTTPoison.get(url, @qualtrics_headers) do
      {:ok, res} ->
        {:ok, data} = Parser.parse(res.body)
        {:ok, data["result"]}
      {:error, _res} ->
        {:error, "Qualtrics contact not found"}
    end
  end

  def survey_completed?(contact_id) do
    case get_contact(contact_id) do
      {:ok, contact} ->
        survey_history = contact["responseHistory"]
        |> Enum.filter(&(&1["surveyId"] == @qualtrics_survey_id))
        |> List.first
        survey_history && survey_history["finishedSurvey"] == true
      {:error, _res} ->
        false
    end
  end

  defp get_distribution_link(url, external_data_reference) do
    {:ok, res} = HTTPoison.get(url, @qualtrics_headers)
    {:ok, data} = Parser.parse(res.body)
    next_page = data["result"]["nextPage"]
    elements = data["result"]["elements"]
    distribution_link =
      elements
      |> Enum.filter(&(&1["externalDataReference"] == external_data_reference))
      |> List.first
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
