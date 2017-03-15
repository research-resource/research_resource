defmodule ResearchResource.Repo.Migrations.CreateTable do
  use Ecto.Migration

  def change do
    create table :users do
      add :ttrrid, :string
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password, :string

      timestamps()
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:ttrrid])
  end
end
