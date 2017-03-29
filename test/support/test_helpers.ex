defmodule ResearchResource.TestHelpers do
  alias ResearchResource.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      first_name: "Some User",
      last_name: "Test",
      email: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}@test.com",
      password: "supersecret",
      ttrrid: "ttrr0000001",
      qualtrics_id: "0"
    }, attrs)

    %ResearchResource.User{}
    |> ResearchResource.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def login_user(%{conn: conn} = config, build_conn, assign) do
    if username = config[:login_as] do
      user = %{email: username, password: "secret"}
        |> Map.merge(if username == "nottrrid@nottrrid.com" do %{ttrrid: nil} else %{} end)
        |> Map.merge(if username == "survey@completed.com" do %{qualtrics_id: "1"} else %{} end)
        |> insert_user
      conn = assign.(build_conn.(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end
end
