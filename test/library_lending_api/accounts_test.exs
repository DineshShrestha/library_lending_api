defmodule LibraryLendingApi.AccountsTest do
  use LibraryLendingApi.DataCase
  alias LibraryLendingApi.Accounts

  test "register_user/1 creates a member with a hashed password" do
    attrs = %{
      name: "Dinesh",
      email: "dinesh@example.com",
      password: "password123"
    }

    assert {:ok, user} = Accounts.register_user(attrs)

    assert user.name == "Dinesh"
    assert user.email == "dinesh@example.com"
    assert user.role == "member"
    assert user.hashed_password != "password123"
  end

  test "authenticate_user/2 returns the user for valid credentials" do
    assert {:ok, registered_user} =
             Accounts.register_user(%{
               name: "Dinesh",
               email: "dinesh@example.com",
               password: "password123"
             })

    assert {:ok, authenticated_user} =
             Accounts.authenticate_user(
               "dinesh@example.com",
               "password123"
             )

    assert authenticated_user.id == registered_user.id
  end

  test "authenticate_user/2 rejects invalid credentials" do
    assert {:ok, _user} =
             Accounts.register_user(%{
               name: "Dinesh",
               email: "dinesh@example.com",
               password: "password123"
             })

    assert {:error, :invalid_credentials} =
             Accounts.authenticate_user(
               "dinesh@example.com",
               "wrong-password"
             )
  end

  test "session token identifies its user" do
    assert {:ok, user} =
             Accounts.register_user(%{
               name: "Dinesh",
               email: "dinesh@example.com",
               password: "password123"
             })

    token = Accounts.generate_user_session_token(user)
    assert is_binary(token)
    assert byte_size(token) == 32

    authenticated_user = Accounts.get_user_by_session_token(token)

    assert authenticated_user.id == user.id
  end
end
