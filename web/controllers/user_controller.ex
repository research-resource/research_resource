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
        send_registration_email(user)
        conn
        |> create_ttrrid(user)
        |> ResearchResource.Auth.login(user)
        |> redirect(to: about_path(conn, :about))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # Update postgres user with a ttrrid.
  # The conn.assigns.current_user used to identify the user is loaded from the postgre value
  def create_ttrrid(conn, user) do
    ttrrid = @id_prefix <> String.rjust(Integer.to_string(user.id), 7, ?0)
    changeset = User.changeset(user, %{"ttrrid" => ttrrid})
    Repo.update(changeset)
    conn
  end

  defp send_registration_email(user) do
    subject = "Welcome to Research Resource"
    message = """
    Dear #{user.first_name},
    Thank you for signing up to the Talking Therapies Research Resource.
    Once you have completed an initial questionnaire, and decided if you are happy to provide a saliva sample, you will be able to sign up to our current projects. It is up to you how many you take part in.
    For more information, please visit our FAQs page. If you still have any questions, you can contact the team by replying to this email, or on FREEPHONE 0800 955 199.
    Kind regards,
    The Talking Therapies Research Resource Team
    """
    ResearchResource.Email.send_email(user.email, subject, message)
    |> ResearchResource.Mailer.deliver_now()
  end
end
