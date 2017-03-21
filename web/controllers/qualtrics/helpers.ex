defmodule ResearchResource.Qualtrics.QualtricsHelpers do
  @moduledoc """
  function helpers for Qualtrics HTTPClient
  """

  @doc """
  see https://api.qualtrics.com/docs/create-recipient-contact
  convert a user model to a simple map
  `externalDataRef` is required
  """
  def user_to_qualtrics_contact(user) do
    %{
      firstName: user.first_name,
      lastName: user.last_name,
      email: user.email,
      externalDataRef: user.ttrrid,
      language: "en-gb",
      unsubscribed: true
    }
  end

end