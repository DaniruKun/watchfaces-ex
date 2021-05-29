defmodule WatchFaces.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :author, :integer
      add :face, :integer

      timestamps()
    end

  end
end
