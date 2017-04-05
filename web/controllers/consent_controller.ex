defmodule ResearchResource.ConsentController do
  use ResearchResource.Web, :controller

  alias ResearchResource.{Redcap.RedcapHelpers, Qualtrics.QualtricsHelpers, User}

  plug :authenticate_user when action in [:new, :create, :view]

  @redcap_api Application.get_env(:research_resource, :redcap_api)
  @qualtrics_api Application.get_env(:research_resource, :qualtrics_api)
  @email Application.get_env(:research_resource, :email)

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
        |> send_saliva_email(consent)
        |> create_user_qualtrics
        |> redirect(to: qualtrics_path(conn, :new))
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
    |> Enum.map(fn {key, val} -> {Regex.replace(~r/_[yn]\b/, key, ""), val} end)
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

  def send_saliva_email(conn, user_details) do
    if (user_details["name"]) do
      subject = "Saliva Kit Requested"
      message = "The following user has requested a saliva kit:\n
      Name: #{user_details["name"]}\n
      Address:
      #{user_details["address_1"]}
      #{user_details["address_2"]}
      #{user_details["town"]}
      #{user_details["county"]}
      #{user_details["postcode"]}"

      ResearchResource.Email.send_email(@email, subject, message)
      |> ResearchResource.Mailer.deliver_now()
    end
    conn
  end
end
