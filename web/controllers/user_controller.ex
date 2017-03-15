defmodule ResearchResource.UserController do
  use ResearchResource.Web, :controller
  alias ResearchResource.User

  def new(conn, _) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

end