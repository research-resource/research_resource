defmodule ResearchResource.TestHelpers do
  alias ResearchResource.{Repo, User}

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      first_name: "Some User",
      last_name: "Test",
      email: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}@test.com",
      password: "supersecret",
      ttrrid: "ttrr0000001",
      qualtrics_id: "0"
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end

  defp add_id_for_username(username) do
    fn (email, map) ->
      if username == email do
        map
      else
        %{}
      end
    end
  end

  def login_user(%{conn: conn} = config, build_conn, assign) do
    if username = config[:login_as] do
      add_id = add_id_for_username(username)
      user = %{email: username, password: "secret"}
        |> Map.merge(add_id.("nottrrid@nottrrid.com", %{ttrrid: nil}))
        |> Map.merge(add_id.("survey@completed.com", %{qualtrics_id: "1"}))
        |> insert_user
      conn = assign.(build_conn.(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end
end
