defmodule ResearchResource.AboutControllerTest do
  use ResearchResource.ConnCase

  test "GET /about", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "About"
  end
end
