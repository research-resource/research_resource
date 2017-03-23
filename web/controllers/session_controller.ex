defmodule ResearchResource.SessionController do
  use ResearchResource.Web, :controller

  alias ResearchResource.Auth

  def new(conn, _) do
    cond do
      conn.assigns[:current_user] ->
        redirect(conn, to: page_path(conn, :index))
      true ->
        render conn, "new.html"
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case Auth.login_by_email_and_password(conn, email, pass, repo: Repo) do
      {:ok, conn} ->
        path = get_session(conn, :redirect_url) || page_path(conn, :index)
        conn
        |> redirect(to: path)
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
