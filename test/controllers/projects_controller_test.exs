defmodule ResearchResource.ProjectsControllerTest do
  use ResearchResource.ConnCase

  test "GET /projects", %{conn: conn} do
    conn = get conn, "/projects"
    assert html_response(conn, 200) =~ "Projects"
  end
end
