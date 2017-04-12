defmodule ResearchResource.AccountController do
  use ResearchResource.Web, :controller

  alias ResearchResource.{Redcap.RedcapHelpers, User, Repo}
  alias Ecto.Multi

  @redcap_api Application.get_env(:research_resource, :redcap_api)

  plug :authenticate_user when action in [:index, :update]

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    user_data =
      conn.assigns.current_user.ttrrid
      |> @redcap_api.get_user_data()

    cond do
      user_data ->
        user_details =
          user_data
          |> Enum.to_list
          |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)
          render conn, "index.html", user_details: user_details, changeset: changeset
      true ->
        redirect(conn, to: consent_path(conn, :new))
    end
  end

  def update(conn, %{"account" => account_params}) do
    old_user =
      conn.assigns.current_user
      |> RedcapHelpers.user_to_record
      |> Enum.filter(fn {key, _val} -> key != :email end)
      |> Enum.into(%{})

    case Repo.transaction(save_update(conn, old_user, account_params)) do
      {:ok, _response} ->
        conn
        |> put_flash(:info, "Profile Updated")
        |> redirect(to: account_path(conn, :index))
      {:error, _failed_operation, %{errors: [email: {message, _}]}, changeset} ->
        conn
        |> put_flash(:error, "Email #{message}")
        |> redirect(to: account_path(conn, :index, changeset: changeset))
      {_, _failed_operation, _failed_value, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: account_path(conn, :index, changeset: changeset))
    end
  end

  defp save_update(conn, user_details, new_user_details) do
    changeset = User.email_changeset(conn.assigns.current_user, new_user_details)

    # Uses Ecto.Multi, so if one function fails, both fail
    # This will prevent the two databases from falling out of sync
    Multi.new
    |> Multi.update(:postgres, changeset)
    |> Multi.run(:redcap, fn _changes_so_far -> @redcap_api.save_record(Map.merge(user_details, new_user_details)) end)
  end
end
