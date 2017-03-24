defmodule ResearchResource.SessionControllerTest do
  use ResearchResource.ConnCase

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(email: username)
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "GET /sessions/new", %{conn: conn} do
    conn = get conn, "/sessions/new"
    assert html_response(conn, 200) =~ "Log In"
  end

  @tag login_as: "me@test.com"
  test "GET /sessions/new - logged in user", %{conn: conn} do
    conn = get conn, "/sessions/new"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "POST /sessions/create - success", %{conn: conn} do
    insert_user(email: "me@test.com", password: "secret")
    conn = post conn, session_path(conn, :create), session: %{email: "me@test.com", password: "secret"}

    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "POST /sessions/create - fail", %{conn: conn} do
    insert_user(email: "me@test.com", password: "secret")
    conn = post conn, session_path(conn, :create), session: %{email: "me@test.com", password: "bad"}

    assert html_response(conn, 200) =~ "Invalid email/password"
  end

  @tag login_as: "me@test.com"
  test "DELETE /sessions/delete - logged in user", %{conn: conn} do
    conn = delete conn, session_path(conn, :delete, conn.assigns.current_user)
    assert redirected_to(conn) == page_path(conn, :index)
  end
end
