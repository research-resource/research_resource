defmodule ResearchResource.TsAndCsControllerTest do
  use ResearchResource.ConnCase

  test "GET /terms_and_conditions", %{conn: conn} do
    conn = get conn, "/terms_and_conditions"
    assert html_response(conn, 200) =~ "T&Cs"
  end
end
