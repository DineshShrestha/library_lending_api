defmodule LibraryLendingApi.Accounts do
  alias LibraryLendingApi.Accounts.User

  alias LibraryLendingApi.Repo

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end
end
