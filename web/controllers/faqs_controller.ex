defmodule ResearchResource.FaqsController do
  use ResearchResource.Web, :controller

  def index(conn, _params) do
    {:ok, data} = File.read("priv/static/faqs.json")
    {:ok, parsed} = Poison.Parser.parse(data)

    %{"faqs" => faqs} = parsed

    render conn, "index.html", faqs: faqs
  end
end
