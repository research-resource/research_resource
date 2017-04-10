defmodule ResearchResource.ProjectsControllerTest do
  use ResearchResource.ConnCase
  setup config do
    login_user(config)
  end

  test "GET /projects", %{conn: conn} do
    conn = get conn, "/projects"
    assert html_response(conn, 200) =~ "Current Projects"
  end

  @tag login_as: "me@test.com"
  test "GET /projects - logged in", %{conn: conn} do
    conn = get conn, "/projects"
    assert html_response(conn, 200) =~ "My Projects"
  end

  test "GET /projects/project_1 - not logged in", %{conn: conn} do
    conn = get conn, "/projects/project_1"
    assert html_response(conn, 200) =~ "project 1"
  end

  @tag login_as: "me@test.com"
  test "GET /projects/project_1", %{conn: conn} do
    conn = get conn, "/projects/project_1"
    assert html_response(conn, 200) =~ "project 1"
  end

  @tag login_as: "nottrrid@nottrrid.com"
  test "GET /projects/project_1 - registration incomplete", %{conn: conn} do
    conn = get conn, "/projects/project_1"
    assert html_response(conn, 200) =~ "project 1"
  end

  @tag login_as: "me@test.com"
  test "Post /project/create", %{conn: conn} do
    consent = %{
      "consent_1_project_1_y" => "Yes",
      "consent_2_project_1_n" => "No",
      "id_project" => "project_1"
     }
    conn = post conn, projects_path(conn, :create), consent: consent
    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == projects_path(conn, :index)
  end
end
