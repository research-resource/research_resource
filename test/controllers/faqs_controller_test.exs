defmodule ResearchResource.FaqsControllerTest do
  use ResearchResource.ConnCase

  test "GET /faqs", %{conn: conn} do
    conn = get conn, "/faqs"
    assert html_response(conn, 200) =~ "FAQS"
  end
end
