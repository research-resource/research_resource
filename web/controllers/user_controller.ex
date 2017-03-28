defmodule ResearchResource.UserController do
  use ResearchResource.Web, :controller
  alias ResearchResource.User

  @id_prefix Application.get_env(:research_resource, :id_prefix)

  def new(conn, _) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        subject = "Welcome to Research Resource"
        message = "Welcome to Research Resource, #{user.first_name}"
        # mail = ResearchResource.Email.send_email(user.email, subject, message)
        # |> ResearchResource.Mailer.deliver_now()
        conn
        |> create_ttrrid(user)
        |> ResearchResource.Auth.login(user)
        |> redirect(to: consent_path(conn, :new))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create_ttrrid(conn, user) do
    ttrrid = @id_prefix <> String.rjust(Integer.to_string(user.id), 7, ?0)
    changeset = User.changeset(user, %{"ttrrid" => ttrrid})
    Repo.update(changeset)
    conn
  end

  def update(conn, %{"user" => %{"email" => email}, "old_user" => old_user_params}) do
    changeset = User.changeset(old_user_params, %{"email" => email})
    Repo.update(changeset)
  end
  def update(conn, _), do: {:ok, "No update to postgres needed"}
end
