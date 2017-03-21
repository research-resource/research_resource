defmodule ResearchResource.Qualtrics.HTTPClient do
  @qualtrics_token Application.get_env(:research_resource, :qualtrics_token)
  @qualtrics_mailinglist_id Application.get_env(:research_resource, :qualtrics_mailinglist_id)

  def create_contact(user) do
    {:ok, payload} = Poison.encode(user)
    header = [{"X-API-TOKEN", @qualtrics_token}, {"Content-Type", "application/json"}]
    url = "https://eu.qualtrics.com/API/v3/mailinglists/#{@qualtrics_mailinglist_id}/contacts"
    HTTPoison.post(url, payload, header)
  end

end