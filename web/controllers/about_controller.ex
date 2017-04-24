defmodule ResearchResource.AboutController do
  use ResearchResource.Web, :controller

  plug :authenticate_user when action in [:about]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def download(conn, _params) do
    if (conn.assigns.current_user) do
      filename = Path.expand("web/static/assets/Information_Sheet_v9.180417_logged_in_user.pdf")
    else
      filename = Path.expand("web/static/assets/Information_Sheet_v9.180417_non_logged_in_user.pdf")
    end
    conn
    |> put_resp_header("content-disposition", ~s(attachment; filename="Information_Sheet.pdf"))
    |> send_file(200, filename)
  end
end
