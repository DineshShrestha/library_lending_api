defmodule LibraryLendingApi.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string, null: false
      add :author, :string, null: false
      add :isbn, :string, null: false
      add :total_copies, :integer, null: false
      add :available_copies, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:books, [:isbn])
    create constraint(:books, :total_copies_must_be_positive, check: "total_copies > 0")

    create constraint(:books, :available_copies_must_be_valid,
             check: "available_copies >=0 AND available_copies <= total_copies"
           )
  end
end
