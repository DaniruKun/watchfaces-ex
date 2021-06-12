defmodule WatchFaces.Repo.Migrations.CreateFaces do
  use Ecto.Migration

  def change do
    create table(:faces) do
      add :name, :string, null: false
      add :user_id, references(:users)
      add :keywords, {:array, :string}
      add :pkg_file, :string
      add :thumbnail, :string

      timestamps()
    end

    create unique_index(:faces, [:user_id])
  end
end
