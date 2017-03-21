defmodule ResearchResource.UserControllerTest do
  use ResearchResource.ConnCase
  alias ResearchResource.Repo
  alias ResearchResource.User

  test "GET /users/new", %{conn: conn} do
    conn = get conn, "/users/new"
    assert html_response(conn, 200) =~ "Create User"
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
    assert redirected_to(conn) == consent_path(conn, :new)
  end

  test "POST /users/create - fail", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{}

    assert html_response(conn, 200) =~ "Create User"
  end
end
