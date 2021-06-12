defmodule WatchFaces.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :name, :string

      timestamps()
    end

  end
end
