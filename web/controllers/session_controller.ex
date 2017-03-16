defmodule ResearchResource.SessionController do
  use ResearchResource.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case ResearchResource.Auth.login_by_email_and_password(conn, email, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end
end