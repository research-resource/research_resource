defmodule ResearchResource.ConsentControllerTest do
  use ResearchResource.ConnCase

  setup config do
    login_user(config)
  end

  @tag login_as: "nottrrid@nottrrid.com"
  test "GET /consent/new - logged in - not in redcap", %{conn: conn} do
    conn = get conn, "/consent/new"
    assert html_response(conn, 200) =~ "Consent"
  end

  @tag login_as: "me@test.com"
  test "GET /consent/new - logged in - in redcap", %{conn: conn} do
    conn = get conn, "/consent/new"
    assert html_response(conn, 302) =~ "/consent/view"
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
  test "Post /consent/create with address", %{conn: conn} do
    conn = post conn, consent_path(conn, :create), consent: %{"consent_1_y" => "Yes", "name" => "Me"}
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

  @tag login_as: "me@test.com"
  test "GET /consent/view", %{conn: conn} do
    conn = get conn, "/consent/view"
    assert html_response(conn, 200) =~ "My Consent"
  end
end
