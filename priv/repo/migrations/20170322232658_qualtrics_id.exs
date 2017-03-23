defmodule ResearchResource.Repo.Migrations.QualtricsId do
  use Ecto.Migration

  def change do
    alter table :users do
      add :qualtrics_id, :string
    end
    create unique_index(:users, [:qualtrics_id])
  end
end
