defmodule ResearchResource.PageControllerTest do
  use ResearchResource.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Research Resource"
  end
end
