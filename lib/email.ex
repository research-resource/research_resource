defmodule ResearchResource.Email do
  use Bamboo.Phoenix, view: SesEmailTest.EmailView

  def send_email(to_email_address, subject, message) do
    new_email()
    |> to(to_email_address)
    |> from("tt.research.resource@gmail.com") # also needs to be a validated email
    |> subject(subject)
    |> text_body(message)
  end
end