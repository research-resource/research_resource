defmodule ResearchResource.AboutControllerTest do
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

  test "GET /about", %{conn: conn} do
    conn = get conn, "/about"
    assert html_response(conn, 200) =~ "About"
  end

  test "GET /about/consent - no access", %{conn: conn} do
    conn = get conn, "/about/consent"
    assert html_response(conn, 302) =~ "redirected"
  end

  @tag login_as: "me@test.com"
  test "GET /about/consent - logged in", %{conn: conn} do
    conn = get conn, "/about/consent"
    assert html_response(conn, 200) =~ "About"
  end


end
