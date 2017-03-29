defmodule ResearchResource.ChangePasswordControllerTest do
  use ResearchResource.ConnCase

  setup config do
    login_user(config)
  end

  @tag login_as: "me@test.com"
  test "GET /change_password - logged in", %{conn: conn} do
    conn = get conn, "/change_password"
    assert html_response(conn, 200) =~ "Change Password"
  end

  test "GET /change_password - not logged in", %{conn: conn} do
    conn = get conn, "/change_password"
    assert html_response(conn, 302) =~ "redirected"
  end

  @tag login_as: "me@test.com"
  test "PUT /change_password/update", %{conn: conn} do
    conn = put conn, change_password_path(conn, :update, conn.assigns.current_user, %{"change_password" => %{
      "old_password" => "secret",
      "new_password" => "supersecret"
    }})
    assert get_flash(conn, :info) == "Password Changed"
  end

  @tag login_as: "error@test.com"
  test "PUT /change_password/update - incorrect", %{conn: conn} do
    conn = put conn, change_password_path(conn, :update, conn.assigns.current_user, %{"change_password" => %{
      "old_password" => "wrong",
      "new_password" => "supersecret"
    }})
    assert get_flash(conn, :error) == "Incorrect old password"
  end

  @tag login_as: "me@test.com"
  test "PUT /change_password/update - error", %{conn: conn} do
    conn = put conn, change_password_path(conn, :update, conn.assigns.current_user, %{"change_password" => %{
      "old_password" => "secret",
      "new_password" => ""
    }})
    assert get_flash(conn, :error) == "Something went wrong"
  end
end
