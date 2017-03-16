defmodule ResearchResource.UserTest do
  use ResearchResource.ModelCase, async: true
  alias ResearchResource.User

  @valid_attrs %{
    first_name: "User",
    last_name: "Test",
    email: "user@test.com",
    password: "secret"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
