defmodule LibraryLendingApiWeb.AuthControllerTest do
  use LibraryLendingApiWeb.ConnCase

  alias LibraryLendingApi.Accounts

  test "POST /api/auth/register creates a member", %{conn: conn} do
    params = %{
      user: %{
        name: "Dinesh",
        email: "dinesh@example.com",
        password: "password123"
      }
    }

    conn = post(conn, ~p"/api/auth/register", params)

    assert %{
             "data" => %{
               "id" => user_id,
               "name" => "Dinesh",
               "email" => "dinesh@example.com",
               "role" => "member"
             }
           } = json_response(conn, 201)

    assert is_integer(user_id)
  end

  test "POST /api/auth/login returns a session token for valid credentials", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.register_user(%{
               name: "Dinesh",
               email: "dinesh@example.com",
               password: "password123"
             })

    params = %{
      credentials: %{
        email: "dinesh@example.com",
        password: "password123"
      }
    }

    conn = post(conn, ~p"/api/auth/login", params)

    assert %{
             "data" => %{
               "token" => token,
               "user" => %{
                 "email" => "dinesh@example.com",
                 "role" => "member"
               }
             }
           } = json_response(conn, 200)

    assert is_binary(token)
    assert token != ""
  end

  test "POST /api/auth/login returns 401 for invalid credentials", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.register_user(%{
               name: "Dinesh",
               email: "dinesh@example.com",
               password: "password123"
             })

    params = %{
      credentials: %{
        email: "dinesh@example.com",
        password: "wrong-password"
      }
    }

    conn = post(conn, ~p"/api/auth/login", params)

    assert %{
             "errors" => %{
               "detail" => "Invalid email or password"
             }
           } = json_response(conn, 401)
  end
end
