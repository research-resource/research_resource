defmodule ResearchResource.ChangePasswordController do
  use ResearchResource.Web, :controller

  alias ResearchResource.{Auth, User}

  plug :authenticate_user when action in [:index, :update]

  def index(conn, _params, _user) do
    render conn, "index.html"
  end

  def update(conn, %{"change_password" => password_params}, user) do
    case Auth.login_by_email_and_password(conn, user.email, password_params["old_password"], repo: Repo) do
      {:ok, conn} ->
        conn
        |> update_password(password_params["new_password"], user)
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Incorrect old password")
        |> render("index.html")
    end
  end

  defp update_password(conn, new_password, current_user) do
    case Repo.update User.registration_changeset(current_user, %{"password" => new_password}) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Password Changed")
        |> redirect(to: change_password_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("index.html")
    end
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

end
