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
    {:ok, payload} = Poison.encode(data)

    body = [
      token: @redcap_token,
      content: "record",
      format: "json",
      type: "flat",
      overwriteBehavior: "normal",
      data: "[#{payload}]"
    ]

    HTTPoison.post(@redcap_url, {:form, body}, [])
  end

  defp filter_fields({:ok, res}, instrument) do
    {:ok, data} = Poison.Parser.parse(res.body)

    Enum.filter(data, fn(question) -> question["form_name"] == instrument end)
  end

  def get_user_data(id) do
    body = [
      token: @redcap_token,
      content: "record",
      format: "json",
      type: "flat",
      records: id
    ]

    {:ok, res} = HTTPoison.post(@redcap_url, {:form, body}, [])
    {:ok, [data]} = Poison.Parser.parse(res.body)

    data
  end
end
