defmodule ResearchResource.ResourcesControllerTest do
  use ResearchResource.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, resources_path(conn, :index)
    assert html_response(conn, 200) =~ "Resources"
  end
end
