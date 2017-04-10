defmodule ResearchResource.Redcap.RedcapHelpers do
  @moduledoc """
  Helpers functions used by Redcap.HTTPClient
  """

  @doc """
  convert an Ecto User model to a simple map
  `record_id` needs to be defined for Redcap to save the record
  """
  def user_to_record(user) do
    %{
      record_id: user.ttrrid,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    }
  end

  @doc """
  convert the value of a map from "Yes" or "No" to 1 or 0
  ## Example
    iex> ResearchResource.Redcap.Helpers.consent_to_record([%{"consent_1" => "Yes", "consent_2" => "No"}])
    %{"consent_1" => 1, "consent_2" => 0}
  """
  def consent_to_record(consent) do

    Map.new(consent,
      fn {k, v} ->
        if Regex.match?(~r/_[yn]\b/, k) do
          {Regex.replace(~r/_[yn]\b/, k, ""), v == "Yes" && 1 || 0}
        else
          {k, v}
        end
      end
    )
  end

end
