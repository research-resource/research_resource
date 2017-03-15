defmodule ResearchResource.User do
  use ResearchResource.Web, :model

  schema "users" do
    field :ttrrid, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w[first_name last_name email])
  end
end