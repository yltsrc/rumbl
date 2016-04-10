defmodule Rumbl.User do
  use Rumbl.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: Ecto.DateTime, usec: true]

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_salt, :string
    field :password_hash, :string
    has_many :videos, Rumbl.Video
    timestamps
  end

  def base_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 1, max: 255)
  end

  def registration_changeset(model, params) do
    model
    |> base_changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6)
    |> unique_constraint(:username)
    |> put_password_hash_with_salt()
  end

  defp put_password_hash_with_salt(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        salt = Comeonin.Bcrypt.gen_salt()
        changeset
        |> put_change(:password_salt, salt)
        |> put_change(:password_hash, Comeonin.Bcrypt.hashpass(pass, salt))
      _ ->
        changeset
    end
  end
end
