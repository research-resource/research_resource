defmodule ResearchResource.ContactControllerTest do
  use ResearchResource.ConnCase

  test "GET /contact", %{conn: conn} do
    conn = get conn, "/contact"
    assert html_response(conn, 200) =~ "Contact Us"
  end
end
