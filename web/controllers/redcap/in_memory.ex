defmodule ResearchResource.Redcap.InMemory do
  alias Poison.Parser

  def save_record(data) do
    case data["email"] do
      "error@test.com" ->
        {:error, "Bad response"}
      _ ->
        {:ok, %HTTPoison.Response{status_code: 200}}
    end
  end

  def get_instrument_fields(_instrument) do
    []
  end

  def get_user_data(nil) do
    # no user found in Redcap
    nil
  end

  def get_user_data(_id) do
    {:ok, response} = Parser.parse ~s({"telephone": "111", "record_id": "123"})
    response
  end

  def get_projects() do
      [
        %{name: "project 1", description: "description of the project 1", id_project: "id_project_1"},
        %{name: "project 2", description: "description of the project 2", id_project: "id_project_2"}
      ]
  end

  def get_project(_id_project) do
    %{
      name: "project 1",
      description: "description of the project 1",
      id_project: "id_project_1",
      consents: []
    }
  end
end
