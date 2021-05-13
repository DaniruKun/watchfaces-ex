defmodule WatchFaces.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password_hash, :string
    field :role, :string
    field :username, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :role, :password_hash])
    |> validate_required([:username, :role, :password_hash])
  end
end
