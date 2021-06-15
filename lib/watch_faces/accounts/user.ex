defmodule WatchFaces.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :string
    field :username, :string
    field :email, :string
    has_many :faces, WatchFaces.Faces.Face

    timestamps()
  end

  @admin_emails ["thedanpetrov@gmail.com", "testadmin@gmail.com"]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_length(:username, min: 1, max: 30)
    |> validate_length(:email, min: 10, max: 50)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> validate_length(:password, min: 8, max: 40)
    |> put_role()
    |> put_pass_hash()
  end

  def google_registration_changeset(user, %{email: email}) do
    attrs = %{email: email, username: username_from_email(email)}

    user
    |> change(attrs)
    |> put_role()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  defp username_from_email(email), do: email |> String.split("@") |> Enum.at(0, "unknown")

  defp put_role(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        role =
          cond do
            email in @admin_emails ->
              "admin"

            true ->
              "regular"
          end

        put_change(changeset, :role, role)

      _ ->
        changeset
    end
  end
end
