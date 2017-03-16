defmodule ResearchResource.TestHelpers do
  alias ResearchResource.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      first_name: "Some User",
      last_name: "Test",
      email: "user#{Base.encode16(:crypto.rand_bytes(8))}@test.com",
      password: "supersecret"
    }, attrs)

    %ResearchResource.User{}
    |> ResearchResource.User.registration_changeset(changes)
    |> Repo.insert!()
  end
end
