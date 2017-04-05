defmodule ResearchResource.ContactControllerTest do
  use ResearchResource.ConnCase
  alias ResearchResource.ContactController

  test "GET /contact", %{conn: conn} do
    conn = get conn, "/contact"
    assert html_response(conn, 200) =~ "Contact Us"
  end

  test "POST /contact/create - request call back all fields", %{conn: conn} do
    conn = post conn, "/contact", callback: %{"name" => "Test", "phone" => "123"}
    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == contact_path(conn, :index)
    assert get_flash(conn, :info)
  end

  test "POST /contact/create - call back missing fields", %{conn: conn} do
    conn = post conn, "/contact", callback: %{"name" => "Test"}
    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == contact_path(conn, :index)
    assert get_flash(conn, :error)
  end

  test "POST /contact/create - message all fields", %{conn: conn} do
    conn = post conn, "/contact", message: %{"name" => "Test", "message" => "hello"}
    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == contact_path(conn, :index)
    assert get_flash(conn, :info)
  end

  test "POST /contact/create - message missing fields", %{conn: conn} do
    conn = post conn, "/contact", message: %{"name" => "Test"}
    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == contact_path(conn, :index)
    assert get_flash(conn, :error)
  end

  test "get referer path" do
    assert ContactController.get_referer_path(%{req_headers: [{"referer", "http://www.google.com/"}]}) == "/"
    assert ContactController.get_referer_path(%{req_headers: [{"referer", "http://www.example.com/helloworld"}]}) == "/helloworld"
    assert ContactController.get_referer_path(%{req_headers: [{"test", "example"}]}) == "/contact"
  end
end
