defmodule ResearchResource.UserControllerTest do
  use ResearchResource.ConnCase

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

    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "POST /users/create - fail", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{}

    assert html_response(conn, 200) =~ "Create User"
  end
end
