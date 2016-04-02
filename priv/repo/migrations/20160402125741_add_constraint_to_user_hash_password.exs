defmodule Rumbl.Repo.Migrations.AddConstraintToUserHashPassword do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :password_hash, :string, null: false
      add :password_salt, :string, null: false
    end
  end
end
