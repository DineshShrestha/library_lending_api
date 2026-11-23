defmodule LibraryLendingApi.Catalog do
  alias LibraryLendingApi.Catalog.Book
  alias LibraryLendingApi.Repo
  import Ecto.Query

  def create_book(attrs) do
    %Book{}
    |> Book.create_changeset(attrs)
    |> Repo.insert()
  end

  def list_books do
    from(book in Book, order_by: [asc: book.id])
    |> Repo.all()
  end

  def get_book(id) do
    from(book in Book, order_by: [asc: book.id])
    |> Repo.get(id)
  end

  def delete_book(id) do
    Repo.delete(id)
  end
end
