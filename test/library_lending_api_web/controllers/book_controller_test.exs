defmodule LibraryLendingApiWeb.BookControllerTest do
  use LibraryLendingApiWeb.ConnCase
  alias LibraryLendingApi.Catalog

  test "POST /api/books creates a book", %{conn: conn} do
    params = %{
      book: %{
        title: "Elixir in Action",
        author: "Sasa Juric",
        isbn: "9781617295027",
        total_copies: 3
      }
    }

    conn = post(conn, ~p"/api/books", params)

    assert %{
             "data" => %{
               "id" => book_id,
               "title" => "Elixir in Action",
               "author" => "Sasa Juric",
               "isbn" => "9781617295027",
               "total_copies" => 3,
               "available_copies" => 3
             }
           } = json_response(conn, 201)

    assert is_integer(book_id)
  end

  test "POST /api/books returns 400 when book parameters are missing", %{conn: conn} do
    conn = post(conn, ~p"/api/books", %{})

    assert %{
             "errors" => %{
               "detail" => "Book parameters are required"
             }
           } = json_response(conn, 400)
  end

  test "GET /api/books returns all books", %{conn: conn} do
    assert {:ok, first_book} =
             Catalog.create_book(%{
               title: "Elixir in Action",
               author: "Sasa Juric",
               isbn: "9781617295027",
               total_copies: 3
             })

    assert {:ok, second_book} =
             Catalog.create_book(%{
               title: "Programming Phoenix",
               author: "Chris McCord",
               isbn: "9781680502268",
               total_copies: 2
             })

    conn = get(conn, ~p"/api/books")

    assert %{
             "data" => books
           } = json_response(conn, 200)

    assert Enum.map(books, & &1["id"]) == [
             first_book.id,
             second_book.id
           ]
  end

  test "GET /api/books/:id returns a book", %{conn: conn} do
    assert {:ok, book} =
             Catalog.create_book(%{
               title: "Elixir in Action",
               author: "Sasa Juric",
               isbn: "9781617295027",
               total_copies: 3
             })

    conn = get(conn, ~p"/api/books/#{book.id}")

    assert %{
             "data" => %{
               "id" => book_id,
               "title" => "Elixir in Action",
               "author" => "Sasa Juric",
               "isbn" => "9781617295027",
               "total_copies" => 3,
               "available_copies" => 3
             }
           } = json_response(conn, 200)

    assert book_id == book.id
  end

  test "GET /api/books/:id returns 404 when the book does not exist", %{conn: conn} do
    conn = get(conn, ~p"/api/books/99999")

    assert %{
             "errors" => %{
               "detail" => "Book not found"
             }
           } = json_response(conn, 404)
  end

  test "DELETE /api/books/:id deletes an existing book", %{conn: conn} do
    {:ok, book} =
      Catalog.create_book(%{
        title: "Elixir in Action",
        author: "Sasa Juric",
        isbn: "9781617295027",
        total_copies: 3
      })

    conn = delete(conn, ~p"/api/books/#{book.id}")

    assert response(conn, 204) == ""
    assert Catalog.get_book(book.id) == nil
  end

  test "DELETE /api/books/:id returns 404 when the book does not exist", %{conn: conn} do
    conn = delete(conn, ~p"/api/books/999999")

    assert %{
             "errors" => %{
               "detail" => "Book not found"
             }
           } = json_response(conn, 404)
  end
end
