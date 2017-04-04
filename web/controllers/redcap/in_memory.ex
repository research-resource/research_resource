defmodule ResearchResource.Redcap.InMemory do
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
    {:ok, response} = Poison.Parser.parse "{\"telephone\": \"111\", \"record_id\": \"123\"}"
    response
  end

  def get_projects() do
    %{"proj1" => %{"name" => "project 1", "description" => "description of the project 1"}}
  end
end
