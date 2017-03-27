defmodule ResearchResource.ConsentView do
  use ResearchResource.Web, :view

  def get_background_colour(index) when rem(index, 2) == 0, do: "bg-near-white"
  def get_background_colour(_index), do: "bg-white"

  def question_name(name, req) do
    case req do
      "y" ->
        String.to_atom("#{name}_y")
      "" ->
        String.to_atom("#{name}_n")
    end
  end
end
