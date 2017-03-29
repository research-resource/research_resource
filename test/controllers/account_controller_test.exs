defmodule ResearchResource.AccountControllerTest do
  use ResearchResource.ConnCase

  alias ResearchResource.{Repo, User}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = %{email: username}
      |> Map.merge(if username == "nottrrid@nottrrid.com" do %{ttrrid: nil} else %{} end)
      |> insert_user
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

  @tag login_as: "nottrrid@nottrrid.com"
  test "GET /account - user not in Redcap", %{conn: conn} do
    conn = get conn, "/account"
    assert html_response(conn, 302) =~ "redirected"
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

  @tag login_as: "noerror@test.com"
  test "PUT /account/update - error", %{conn: conn} do
    conn = put conn, account_path(conn, :update, conn.assigns.current_user, %{"account" => %{"email": "error@test.com"}})
    assert Repo.get_by(User, email: "noerror@test.com")
    # Does not update postgres if redcap fails
    refute Repo.get_by(User, email: "error@test.com")
    assert get_flash(conn, :error) == "Something went wrong"
  end

  @tag login_as: "me@test.com"
  test "PUT /account/update - email already taken", %{conn: conn} do
    insert_user(%{email: "hello@test.com", ttrrid: "TEST", qualtrics_id: "TEST"})
    conn = put conn, account_path(conn, :update, conn.assigns.current_user, %{"account" => %{"email": "hello@test.com"}})
    assert get_flash(conn, :error) == "Email has already been taken"
  end
end
