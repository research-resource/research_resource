defmodule ResearchResource.ComponentView do
  use ResearchResource.Web, :view

  # Consent Question helpers
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

  def get_checked_yes(checked), do: checked == "1"

  def get_checked_no(checked), do: checked == "0"

  def truncate(text, limit_characters) do
    if String.length(text) < limit_characters do
      text
    else
      String.slice(text, 0..limit_characters) <> "..."
    end
  end
end
