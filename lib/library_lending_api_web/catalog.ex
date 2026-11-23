defmodule LibraryLendingApi.Catalog do
  alias LibraryLendingApi.Catalog.Book
  alias LibraryLendingApi.Repo

  def create_book(attrs) do
    %Book{}
    |> Book.create_changeset(attrs)
    |> Repo.insert()
  end
end
