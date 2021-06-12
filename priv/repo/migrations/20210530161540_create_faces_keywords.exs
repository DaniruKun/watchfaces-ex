defmodule WatchFaces.Repo.Migrations.CreateFacesKeywords do
  use Ecto.Migration

  def change do
    create table(:faces_keywords) do
      add :face_id, references(:faces)
      add :keyword_id, references(:keywords)
    end

    create unique_index(:faces_keywords, [:face_id, :keyword_id])
  end
end
