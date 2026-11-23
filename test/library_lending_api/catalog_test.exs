defmodule LibraryLendingApi.CatalogTest do
  use LibraryLendingApi.DataCase

  alias LibraryLendingApi.Catalog

  test "create_book/1 creates a book with valid attributes" do
    attrs = %{
      title: "Elixir in Action",
      author: "Sasa Juric",
      isbn: "9781617295027",
      total_copies: 3
    }

    assert {:ok, book} = Catalog.create_book(attrs)

    assert book.title == "Elixir in Action"
    assert book.author == "Sasa Juric"
    assert book.isbn == "9781617295027"
    assert book.total_copies == 3
    assert book.available_copies == 3
  end

  test "create_book/1 rejects a non-positive copy count" do
    attrs = %{
      title: "Programming Phoenix",
      author: "Chris McCord",
      isbn: "9781680502268",
      total_copies: 0
    }

    assert {:error, changeset} = Catalog.create_book(attrs)
    assert "must be greater than 0" in errors_on(changeset).total_copies
  end

  test "create_book/1 rejects a duplicate ISBN" do
    attrs = %{
      title: "Elixir in Action",
      author: "Sasa Juric",
      isbn: "9781617295027",
      total_copies: 3
    }

    assert {:ok, _book} = Catalog.create_book(attrs)
    assert {:error, changeset} = Catalog.create_book(attrs)

    assert "has already been taken" in errors_on(changeset).isbn
  end
end
