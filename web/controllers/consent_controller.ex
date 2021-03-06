defmodule ResearchResource.ConsentController do
  use ResearchResource.Web, :controller

  alias ResearchResource.{Redcap.RedcapHelpers, Qualtrics.QualtricsHelpers, User}

  plug :authenticate_user when action in [:new, :create, :view, :confirm]

  @redcap_api Application.get_env(:research_resource, :redcap_api)
  @qualtrics_api Application.get_env(:research_resource, :qualtrics_api)
  @contact_email Application.get_env(:research_resource, :contact_email)

  def new(conn, _params) do
    case conn.assigns.current_user.ttrr_consent do
      true ->
        redirect(conn, to: consent_path(conn, :view))
      _ ->
        render(conn, "new.html", consent_questions: @redcap_api.get_instrument_fields("consent"))
    end
  end

  # save user and consent
  def create(conn, %{"consent" => consent}) do
    case check_consent(consent) do
      true ->
        conn
        |> create_user_redcap(consent)
        |> update_consent
        |> create_user_qualtrics
        |> send_saliva_email(consent)
        |> case do
          {:ok, :sent} ->
            redirect(conn, to: consent_path(conn, :confirm))
          {:ok, :not_sent} ->
            redirect(conn, to: qualtrics_path(conn, :new))
        end
      false ->
        conn
        |> put_flash(:error, "You must consent to the required questions")
        |> redirect(to: consent_path(conn, :new))
    end
  end

  # redirect to the consent page if the form is submitted without any values (consent map is not defined)
  def create(conn, _) do
    redirect(conn, to: consent_path(conn, :new))
  end

  def create_user_redcap(conn, consent) do
    user_data = RedcapHelpers.user_to_record(conn.assigns.current_user)

    consent
    |> Enum.filter(fn {key, _} -> String.starts_with?(key, "consent") end)
    |> RedcapHelpers.consent_to_record
    |> Map.merge(user_data)
    |> Map.merge(%{user_details_complete: 2, consent_complete: 2})
    |> @redcap_api.save_record

    conn
  end

  def create_user_qualtrics(conn) do
    contact_qualtrics = QualtricsHelpers.user_to_qualtrics_contact(conn.assigns.current_user)

    case @qualtrics_api.create_contact(contact_qualtrics) do
      {:ok, id} ->
        # update user model and postgres data with qualtrics id
        changeset = User.changeset(conn.assigns.current_user, %{"qualtrics_id" => id} )
        case Repo.update(changeset) do
          {:ok, user} ->
            conn
            |> assign(:current_user, user)
        end
    end
  end

  defp check_consent(consent) do
    Enum.all?(consent, fn {k, v} ->
      case String.last(k) do
        "y" ->
          if String.starts_with?(k, "consent") do
            v == "Yes"
          else
            true
          end
        _ ->
          true
        end
    end)
  end

  def view(conn, _params) do
    render(conn, "view.html",
      consent_questions: @redcap_api.get_instrument_fields("consent"),
      consent_answers: @redcap_api.get_user_data(conn.assigns.current_user.ttrrid)
    )
  end

  def update_consent(conn) do
    changeset = User.changeset(conn.assigns.current_user, %{"ttrr_consent" => true} )

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
    end
  end

  def send_saliva_email(_conn, user_details) do
    if (Map.has_key?(user_details, "name") and
      Map.has_key?(user_details, "address_1") and
      user_details["name"] != "" and
      user_details["address_1"] != ""
    ) do
      subject = "Saliva Kit Requested"
      message = "The following user has requested a saliva kit:\n
      Name: #{user_details["name"]}\n
      Address:
      #{user_details["address_1"]}
      #{user_details["address_2"]}
      #{user_details["town"]}
      #{user_details["county"]}
      #{user_details["postcode"]}"

      ResearchResource.Email.send_email(@contact_email, subject, message)
      |> ResearchResource.Mailer.deliver_now()

      {:ok, :sent}
    else
      {:ok, :not_sent}
    end
  end

  def confirm(conn, _params) do
    render conn, "confirm.html"
  end
end
