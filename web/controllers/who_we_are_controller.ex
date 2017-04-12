defmodule ResearchResource.WhoWeAreController do
  use ResearchResource.Web, :controller

  alias Poison.Parser

  def index(conn, _params) do
    {:ok, data} = File.read("priv/static/who_we_are.json")
    {:ok, parsed} = Parser.parse(data)

    %{"support_team" => support_team, "investigators" => investigators} = parsed

    render conn, "index.html", support_team: support_team, investigators: investigators
  end
end
