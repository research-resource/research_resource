defmodule ResearchResource.Redcap.HTTPClient do
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

  def save_record(data) do
    # add complete status to the record
    record = Map.merge(data, %{user_details_complete: 2, consent_complete: 2})

    {:ok, payload} = Poison.encode(record)
    body = [
      token: @redcap_token,
      content: "record",
      format: "json",
      type: "flat",
      overwriteBehavior: "normal",
      data: "[#{payload}]"
    ]

    res = HTTPoison.post(@redcap_url, {:form, body}, [])
  end

  defp filter_fields({:ok, res}, instrument) do
    {:ok, data} = Poison.Parser.parse(res.body)

    consent_questions = Enum.filter(data, fn(question) -> question["form_name"] == instrument end)
  end
end