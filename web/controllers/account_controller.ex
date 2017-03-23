defmodule ResearchResource.AccountController do
  use ResearchResource.Web, :controller
  alias ResearchResource.Redcap.RedcapHelpers

  @redcap_api Application.get_env(:research_resource, :redcap_api)

  plug :authenticate_user when action in [:index]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def update(conn, %{"account" => account_params}) do
    RedcapHelpers.user_to_record(conn.assigns.current_user)
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
