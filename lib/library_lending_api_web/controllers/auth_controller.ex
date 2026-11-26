defmodule LibraryLendingApiWeb.AuthController do
  use LibraryLendingApiWeb, :controller
  alias LibraryLendingApi.Accounts

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{
          data: %{
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role
          }
        })

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: %{
            detail: "User cannot be created"
          }
        })
    end
  end

  def login(conn, %{
        "credentials" => %{
          "email" => email,
          "password" => password
        }
      }) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        token =
          user
          |> Accounts.generate_user_session_token()
          |> Base.url_encode64(padding: false)

        json(conn, %{
          data: %{
            token: token,
            user: %{
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role
            }
          }
        })

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          errors: %{
            detail: "Invalid email or password"
          }
        })
    end
  end
end
