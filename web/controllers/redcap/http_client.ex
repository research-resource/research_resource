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

    case HTTPoison.post(@redcap_url, {:form, body}, []) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, %HTTPoison.Response{status_code: 200}}
      {_, response} ->
        {:error, response}
    end
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
    case Poison.Parser.parse(res.body) do
      {:ok, []} -> nil
      {:ok, [data]} -> data
    end
  end

  def get_projects() do
    {:ok, res} = HTTPoison.post(@redcap_url, {:form,
      [token: @redcap_token,
      content: "metadata",
      format: "json"
    ]}, %{})
    {:ok, data} = Poison.Parser.parse(res.body)
    projects = filter_projects(data)
  end

  def get_project(id_project) do
    fields = get_instrument_fields(id_project)
    info = Enum.filter(fields, &(Enum.member?(~w(name description status), &1["field_label"])))
    consents = Enum.filter(fields, &(!Enum.member?(~w(name description status), &1["field_label"])))
    Map.merge(%{consents: consents}, info_project({id_project, info}))
  end

  @doc """
  Filter and convert a list of Redcap fields:
  [%{name: "project name", description: "description of the project"}, ...]
 """
  defp filter_projects(data) do
    data
    |> Enum.filter(fn(question) -> question["form_name"] =~ ~r/^project/ end)
    |> Enum.filter(fn(question) -> Enum.member?(~w(name description status), question["field_label"]) end)
    |> Enum.group_by(fn(question) -> question["form_name"] end)
    |> Enum.map(&(info_project(&1)))
  end

  defp info_project({id_project, values}) do
    Map.new(values, fn %{"field_label" => label, "field_annotation" => annotation} ->
      {String.to_atom(label), annotation}
    end)
    |> Map.put(:id_project, id_project)
  end
end
