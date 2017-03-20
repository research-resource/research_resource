defmodule ResearchResource.ConsentView do
  use ResearchResource.Web, :view

  def get_background_colour(index) when rem(index, 2) == 0, do: "bg-light-gray"
  def get_background_colour(index), do: "bg-white"
end
