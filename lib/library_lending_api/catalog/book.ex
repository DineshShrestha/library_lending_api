defmodule LibraryLendingApi.Catalog.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :author, :string
    field :isbn, :string
    field :total_copies, :integer
    field :available_copies, :integer
    timestamps(type: :utc_datetime)
  end

  def create_changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :isbn, :total_copies])
    |> validate_required([:title, :author, :isbn, :total_copies])
    |> validate_number(:total_copies, greater_than: 0)
    |> set_available_copies()
    |> unique_constraint(:isbn)
    |> check_constraint(:total_copies, name: :total_copies_must_be_positive)
    |> check_constraint(:available_copies, name: :available_copies_must_be_valid)
  end

  defp set_available_copies(changeset) do
    case get_field(changeset, :total_copies) do
      total_copies when is_integer(total_copies) and total_copies > 0 ->
        put_change(changeset, :available_copies, total_copies)

      _ ->
        changeset
    end
  end
end
