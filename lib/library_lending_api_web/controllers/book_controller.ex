defmodule LibraryLendingApiWeb.BookController do
  use LibraryLendingApiWeb, :controller

  alias LibraryLendingApi.Catalog

  def create(conn, %{"book" => book_params}) do
    case Catalog.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_status(:created)
        |> json(%{
          data: %{
            id: book.id,
            title: book.title,
            author: book.author,
            isbn: book.isbn,
            total_copies: book.total_copies,
            available_copies: book.available_copies
          }
        })

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: %{
            detail: "Book could not be added"
          }
        })
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{
      errors: %{
        detail: "Book parameters are required"
      }
    })
  end

  def index(conn, _params) do
    books = Catalog.list_books()

    data =
      Enum.map(books, fn book ->
        %{
          id: book.id,
          title: book.title,
          author: book.author,
          isbn: book.isbn,
          total_copies: book.total_copies
        }
      end)

    json(conn, %{data: data})
  end

  def show(conn, %{"id" => id}) do
    case Catalog.get_book(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          errors: %{
            detail: "Book not found"
          }
        })

      book ->
        json(conn, %{
          data: %{
            id: book.id,
            title: book.title,
            author: book.author,
            isbn: book.isbn,
            total_copies: book.total_copies,
            available_copies: book.available_copies
          }
        })
    end
  end

  def delete(conn, %{"id" => id}) do
    case Catalog.get_book(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          errors: %{
            detail: "Book not found"
          }
        })

      book ->
        case Catalog.delete_book(book) do
          {:ok, _delete_book} ->
            send_resp(conn, :no_content, "")

          {:error, _changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
              errors: %{
                detail: "Book could not be deleted"
              }
            })
        end
    end
  end
end
