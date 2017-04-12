defmodule ResearchResource.ComponentHelpers do
  alias ResearchResource.ComponentView
  alias ResearchResource.User

  def component(template, assigns) do
    ComponentView.render("#{template}.html", assigns)
  end

  def create_user_changeset(changeset) when changeset != nil, do: changeset
  def create_user_changeset(_), do: User.changeset(%User{})
end
