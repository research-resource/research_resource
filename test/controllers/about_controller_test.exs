defmodule ResearchResource.AboutControllerTest do
  use ResearchResource.ConnCase

  setup config do
    login_user(config)
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

  test "GET /about/download", %{conn: conn} do
    conn = get conn, "/about/download"
    assert conn.status == 200
  end

  @tag login_as: "me@test.com"
  test "GET /about/download - logged in", %{conn: conn} do
    conn = get conn, "/about/download"
    assert conn.status == 200
  end
end
