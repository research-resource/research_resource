defmodule ResearchResource.User do
  use ResearchResource.Web, :model

  schema "users" do
    field :ttrrid, :string
    field :qualtrics_id, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w[first_name last_name email ttrrid qualtrics_id])
    |> validate_required([:first_name, :last_name, :email])
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password))
    |> validate_required([:password])
    |> put_pass_hash()
  end

  def email_changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w(email))
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
