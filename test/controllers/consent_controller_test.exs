defmodule ResearchResource.ConsentControllerTest do
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

  @tag login_as: "me@test.com"
  test "GET /consent - logged in", %{conn: conn} do
    conn = get conn, "/consent"
    assert html_response(conn, 200) =~ "Consent"
  end

  test "GET /consent - not logged in", %{conn: conn} do
    conn = get conn, "/consent"
    assert html_response(conn, 302) =~ "redirected"
  end
end
