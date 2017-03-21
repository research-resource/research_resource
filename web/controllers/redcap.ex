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

  def save_record(data) do
    {:ok, payload} = Poison.encode(data)
    IO.puts payload
    IO.puts "******************"
    res = HTTPoison.post(@redcap_url, {:form,
    [token: @redcap_token,
     content: "record",
     format: "json",
     type: "flat",
     overwriteBehavior: "normal",
     data: payload
    ]}, [])
    IO.inspect res
  end

  defp filter_fields({:ok, res}, instrument) do
    {:ok, data} = Poison.Parser.parse(res.body)

    consent_questions = Enum.filter(data, fn(e) -> e["form_name"] == instrument end)
  end


end
