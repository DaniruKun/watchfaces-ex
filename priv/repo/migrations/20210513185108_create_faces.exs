defmodule WatchFaces.Repo.Migrations.CreateFaces do
  use Ecto.Migration

  def change do
    create table(:faces) do
      add :name, :string
      add :author, :integer
      add :keywords, {:array, :string}
      add :pkg_file, :string
      add :thumbnail, :string

      timestamps()
    end

  end
end
