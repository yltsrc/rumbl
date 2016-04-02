defmodule Rumbl.User do
  use Rumbl.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: Ecto.DateTime, usec: true]

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 1, max: 255)
  end
end
