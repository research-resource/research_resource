defmodule ResearchResource.UserController do
  use ResearchResource.Web, :controller
  alias ResearchResource.User


  def new(conn, _) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> create_ttrrid(user)
        |> ResearchResource.Auth.login(user)
        |> redirect(to: consent_path(conn, :new))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create_ttrrid(conn, user) do
    ttrrid = "TTRR" <> String.rjust(Integer.to_string(user.id), 7, ?0)
    changeset = User.changeset(user, %{"ttrrid" => ttrrid})
    Repo.update(changeset)
    conn
  end
end
