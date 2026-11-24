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
end
