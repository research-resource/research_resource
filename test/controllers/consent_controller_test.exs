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
  test "GET /consent/new - logged in", %{conn: conn} do
    conn = get conn, "/consent/new"
    assert html_response(conn, 200) =~ "Consent"
  end

  test "GET /consent - not logged in", %{conn: conn} do
    conn = get conn, "/consent/new"
    assert html_response(conn, 302) =~ "redirected"
  end

  test "POST /consent/create - not logged in", %{conn: conn} do
    conn = post conn, consent_path(conn, :create), consent: %{}
    assert html_response(conn, 302) =~ "redirected"
  end

  @tag login_as: "me@test.com"
  test "Post /consent/create - not consent payload", %{conn: conn} do
    conn = post conn, consent_path(conn, :create), nopayload: %{}
    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == consent_path(conn, :new)
  end

  @tag login_as: "me@test.com"
  test "Post /consent/create", %{conn: conn} do
    conn = post conn, consent_path(conn, :create), consent: %{"consent_1_y" => "Yes", "consent_2_n" => "No"}
    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == qualtrics_path(conn, :new)
  end

  @tag login_as: "me@test.com"
  test "Post /consent/create - required with no consent", %{conn: conn} do
    conn = post conn, consent_path(conn, :create), consent: %{"consent_2_y" => "No"}
    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == consent_path(conn, :new)
    assert get_flash(conn, :error)
  end
end
