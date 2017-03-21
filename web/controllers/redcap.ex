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

  def user_to_record(user) do
    %{
      record_id: user.ttrrid,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    }
  end

  # convert yes/no to 1/0
  def consent_to_record(consent) do
    # %{"consent_1" => "Yes", "consent_2" => "No", ... } to
    # %{"consent_1" => 1, "consent_2" => 0, ... }
    for {k, v} <- consent, into: %{}, do: {k, bool_to_num(v)}
  end

  defp bool_to_num(value) do
    if value == "Yes" do
      1
    else
      0
    end
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

    consent_questions = Enum.filter(data, fn(e) -> e["form_name"] == instrument end)
  end


end
