defmodule ResearchResource.ComponentViewTest do
  use ResearchResource.ConnCase
  alias ResearchResource.ComponentView

  test "creates form names correctly" do
    assert ComponentView.question_name("consent_1", "y") == :consent_1_y
    assert ComponentView.question_name("consent_2", "") == :consent_2_n
    assert ComponentView.question_name("consent_44", "") == :consent_44_n
    assert ComponentView.question_name("consent_80", "y") == :consent_80_y
  end

  test "get checked yes" do
    assert ComponentView.get_checked_yes("1") == true
    assert ComponentView.get_checked_yes("0") == false
  end

  test "get checked no" do
    assert ComponentView.get_checked_no("1") == false
    assert ComponentView.get_checked_no("0") == true
  end
end
