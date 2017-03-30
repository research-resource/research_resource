defmodule ResearchResource.UserControllerTest do
  use ResearchResource.ConnCase
  use Bamboo.Test

  alias ResearchResource.{Repo, User, Email}

  test "GET /users/new", %{conn: conn} do
    conn = get conn, "/users/new"
    assert html_response(conn, 200) =~ "Sign Up"
  end

  test "POST /users/create - success", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{
      email: "me@test.com",
      password: "secret",
      first_name: "User",
      last_name: "Test"
    }
    user = Repo.get_by!(User, email: "me@test.com")
    assert user.ttrrid =~ "TTRR"
    assert String.length(user.ttrrid) == 11
    assert redirected_to(conn) == about_path(conn, :about)
  end

  test "POST /users/create - fail", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{}

    assert html_response(conn, 200) =~ "Sign Up"
  end

  test "Create welcome email" do
    email = Email.send_email("test@email.com", "Welcome to Research Resource", "Welcome Test")
    assert email.to == "test@email.com"
    assert email.subject == "Welcome to Research Resource"
    assert email.text_body == "Welcome Test"
  end

  test "Send Welcome email" do
    email = Email.send_email("test@email.com", "Welcome to Research Resource", "Welcome Test")
    email |> ResearchResource.Mailer.deliver_now
    assert_delivered_email Email.send_email("test@email.com", "Welcome to Research Resource", "Welcome Test")
  end
end
