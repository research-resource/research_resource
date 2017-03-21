defmodule ResearchResource.QualtricsControllerTest do
  use ResearchResource.ConnCase

  test "GET /qualtrics/new", %{conn: conn} do
    conn = get conn, "/qualtrics/new"
    assert html_response(conn, 200) =~ "Qualtrics Questionnaire"
  end
end
