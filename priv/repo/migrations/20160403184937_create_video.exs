defmodule Rumbl.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  def change do
    create table(:videos, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :url, :string, null: false
      add :title, :string, null: false
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      timestamps
    end

    create index(:videos, [:user_id])
  end
end
