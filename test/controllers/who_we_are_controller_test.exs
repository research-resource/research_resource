defmodule ResearchResource.WhoWeAreControllerTest do
  use ResearchResource.ConnCase

  test "GET /who", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Who We Are"
  end
end
