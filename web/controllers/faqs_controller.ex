defmodule ResearchResource.FaqsController do
  use ResearchResource.Web, :controller
  
  alias Poison.Parser

  def index(conn, _params) do
    {:ok, data} = File.read("priv/static/faqs.json")
    {:ok, %{"faqs" => faqs}} = Parser.parse(data)

    render conn, "index.html", faqs: faqs
  end
end
