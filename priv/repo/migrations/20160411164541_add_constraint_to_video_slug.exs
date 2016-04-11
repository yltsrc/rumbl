defmodule Rumbl.Repo.Migrations.AddConstraintToVideoSlug do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      modify :slug, :string, null: false
    end
  end
end
