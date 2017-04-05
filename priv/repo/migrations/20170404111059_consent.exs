defmodule ResearchResource.Repo.Migrations.Consent do
  use Ecto.Migration

  def change do
    alter table :users do
      add :ttrr_consent, :boolean, default: false
    end
  end
end
