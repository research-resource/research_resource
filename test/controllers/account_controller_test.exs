defmodule ResearchResource.AccountControllerTest do
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
  test "GET /account - logged in", %{conn: conn} do
    conn = get conn, "/account"
    assert html_response(conn, 200) =~ "Welcome"
  end

  test "GET /account - not logged in", %{conn: conn} do
    conn = get conn, "/account"
    assert html_response(conn, 302) =~ "redirected"
  end

  @tag login_as: "me@test.com"
  test "PUT /account/update", %{conn: conn} do
    conn = put conn, account_path(conn, :update, conn.assigns.current_user, %{"account" => %{telephone: "123"}})
    assert get_flash(conn, :info) == "Profile Updated"
  end

  @tag login_as: "error@test.com"
  test "PUT /account/update - error", %{conn: conn} do
    conn = put conn, account_path(conn, :update, conn.assigns.current_user, %{"account" => %{"email": "error@test.com"}})
    assert get_flash(conn, :error) == "Something went wrong"
  end
end
