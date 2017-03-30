defmodule ResearchResource.Email do
  use Bamboo.Phoenix, view: SesEmailTest.EmailView
  @email Application.get_env(:research_resource, :email)

  def send_email(to_email_address, subject, message) do
    new_email()
    |> to(to_email_address)
    |> from(@email)
    |> subject(subject)
    |> text_body(message)
  end
end