defmodule WatchFaces.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text, null: false
      add :author, references(:users)
      add :face, references(:faces)

      timestamps()
    end
  end
end
