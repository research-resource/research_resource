defmodule ResearchResource.ConsentViewTest do
  use ResearchResource.ConnCase
  alias ResearchResource.ConsentView

  test "creates form names correctly" do
    assert ConsentView.question_name("consent_1", "y") == :consent_1_y
    assert ConsentView.question_name("consent_2", "") == :consent_2_n
    assert ConsentView.question_name("consent_44", "") == :consent_44_n
    assert ConsentView.question_name("consent_80", "y") == :consent_80_y
  end

  test "get checked yes" do
    assert ConsentView.get_checked_yes("1") == true
    assert ConsentView.get_checked_yes("0") == false
  end

  test "get checked no" do
    assert ConsentView.get_checked_no("1") == false
    assert ConsentView.get_checked_no("0") == true
  end
end
