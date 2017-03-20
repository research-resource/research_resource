defmodule ResearchResource.Redcap do
  @redcap_url Application.get_env(:research_resource, :redcap_url)
  @redcap_token Application.get_env(:research_resource, :redcap_token)

  def get_instrument_fields(instrument) do
    res = HTTPoison.post(@redcap_url, {:form,
      [token: @redcap_token,
      content: "metadata",
      format: "json"
    ]}, %{})

    filter_fields(res, instrument)
  end

  defp filter_fields({:ok, res}, instrument) do
    {:ok, data} = Poison.Parser.parse(res.body)

    consent_questions = Enum.filter(data, fn(e) -> e["form_name"] == instrument end)
  end
end
