defmodule ResearchResource.ContactController do
  use ResearchResource.Web, :controller

  @contact_email Application.get_env(:research_resource, :contact_email)

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn,
    %{"callback" => %{"name" => name, "phone" => phone} = callback}
  ) when name != "" and phone != "" do
    conn
    |> send_callback_email(callback)
    |> put_flash(:info, "Thank you for requesting a call back, one of our staff will be in touch soon.")
    |> redirect(to: get_referer_path(conn))
  end
  def create(conn,
    %{"message" => %{"name" => name, "message" => message} = details}
  ) when name != "" and message != "" do
    conn
    |> send_message_email(details)
    |> put_flash(:info, "Thank you for your message, one of our staff will be in touch soon.")
    |> redirect(to: get_referer_path(conn))
  end
  def create(conn, _) do
    conn
    |> put_flash(:error, "Please fill all fields in one of the forms.")
    |> redirect(to: get_referer_path(conn))
  end

  defp send_callback_email(conn, details) do
    subject = "Call Back Requested"
    message = "The following user has requested a call back:\n
    Name: #{details["name"]}\n
    Phone Number: #{details["phone"]}
    Best Time to Call: #{details["time"]}"

    @contact_email
    |> ResearchResource.Email.send_email(subject, message)
    |> ResearchResource.Mailer.deliver_now()

    conn
  end

  defp send_message_email(conn, details) do
    subject = "Message Received"
    message = "Message Received:\n
    Name: #{details["name"]}\n
    Email: #{details["email"]}
    Phone Number: #{details["phone"]}
    Message: #{details["message"]}"

    @contact_email
    |> ResearchResource.Email.send_email(subject, message)
    |> ResearchResource.Mailer.deliver_now()

    conn
  end

  @doc """
  Find page user came from so we can redirect back there with a message.
  If no referer, defaults to 'contact' page
  """
  def get_referer_path(conn) do
    case Enum.find(conn.req_headers, fn({key, _}) -> key == "referer" end) do
      {"referer", referer} ->
        URI.parse(referer).path
      _ ->
        "/contact"
    end
  end
end
