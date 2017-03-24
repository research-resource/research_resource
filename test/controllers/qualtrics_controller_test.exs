defmodule ResearchResource.QualtricsControllerTest do
  use ResearchResource.ConnCase

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = %{email: username}
      |> Map.merge(if username == "survey@completed.com" do %{qualtrics_id: "1"} else %{} end)
      |> insert_user
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end



  @tag login_as: "me@test.com"
  test "GET /qualtrics/new - found survey link", %{conn: conn} do
    conn = get conn, "/qualtrics/new"
    assert html_response(conn, 200) =~ "Qualtrics Questionnaire"
  end

  @tag login_as: "not@found.com"
  test "GET /qualtrics/new - not found survey link in Qualtrics", %{conn: conn} do
    conn = get conn, "/qualtrics/new"
    assert html_response(conn, 200) =~ "no Qualtrics questionnaire found"
  end

  @tag login_as: "survey@completed.com"
  test "GET /qualtrics/new - survey already completed", %{conn: conn} do
    conn = get conn, "/qualtrics/new"
    assert html_response(conn, 302) =~ "redirected"
  end

  test "GET /qualtrics/new - not logged in", %{conn: conn} do
    conn = get conn, "/qualtrics/new"
    assert html_response(conn, 302) =~ "redirected"
  end

end
