defmodule ResearchResource.ProjectsView do
  use ResearchResource.Web, :view

  def error_message_consent() do
    "If you do not consent to this option, you will not be able to join this project"
  end
end
