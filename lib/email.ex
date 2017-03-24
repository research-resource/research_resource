defmodule SesEmailTest.Email do
  use Bamboo.Phoenix, view: SesEmailTest.EmailView

  def send_test_email(from_email_address, subject, message) do
    new_email()
    |> to("yourvalidatedemail@example.com")
    |> from(from_email_address) # also needs to be a validated email
    |> subject(subject)
    |> text_body(message)
  end
end