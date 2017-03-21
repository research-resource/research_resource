defmodule ResearchResource.ComponentHelpers do
  alias ResearchResource.ComponentView

  def component(template, assigns) do
    ComponentView.render("#{template}.html", assigns)
  end
end
