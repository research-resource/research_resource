defmodule ResearchResource.AccountController do
  use ResearchResource.Web, :controller
  alias ResearchResource.Redcap.RedcapHelpers

  @redcap_api Application.get_env(:research_resource, :redcap_api)

  plug :authenticate_user when action in [:index, :update]

  def index(conn, _params) do
    user_details =
      conn.assigns.current_user.ttrrid
      |> @redcap_api.get_user_data()
      # Turn user data from a map to a keyword list
      |> Enum.to_list
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    render conn, "index.html", user_details: user_details
  end

  def update(conn, %{"account" => account_params}) do
    conn.assigns.current_user
    |> RedcapHelpers.user_to_record
    |> Enum.filter(fn {key, val} -> key != :email end)
    |> Enum.into(%{})
    |> Map.merge(account_params)
    |> @redcap_api.save_record
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        conn
        |> put_flash(:info, "Profile Updated")
        |> redirect(to: account_path(conn, :index))
      _ ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: account_path(conn, :index))
    end
  end
end
