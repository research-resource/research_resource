defmodule ResearchResource.Redcap.Helpers do
  def user_to_record(user) do
    %{
      record_id: user.ttrrid,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    }
  end

  # convert yes/no to 1/0
  # %{"consent_1" => "Yes", "consent_2" => "No", ... } to %{"consent_1" => 1, "consent_2" => 0, ... }
  def consent_to_record(consent) do
    for {k, v} <- consent, into: %{}, do: {k, bool_to_num(v)}
  end

  defp bool_to_num("Yes"), do: 1
  defp bool_to_num(_), do: 0

end