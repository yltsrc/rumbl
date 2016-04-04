defmodule Rumbl.Repo.Migrations.AddCategoryIdToVideo do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)
    end
  end
end
