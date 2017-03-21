defmodule ResearchResource.Redcap.InMemory do
  def save_record(_data) do
    {:ok, "Redcap API response"}
  end

  def get_instrument_fields(_instrument) do
    []
  end
end