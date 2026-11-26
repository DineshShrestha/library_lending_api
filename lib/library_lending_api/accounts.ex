defmodule LibraryLendingApi.Accounts do
  alias LibraryLendingApi.Accounts.User
  alias LibraryLendingApi.Accounts.UserToken
  alias LibraryLendingApi.Repo

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    if User.valid_password?(user, password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  def generate_user_session_token(user) do
    token = :crypto.strong_rand_bytes(32)

    {:ok, _user_token} =
      %UserToken{
        token: token,
        context: "session",
        user_id: user.id
      }
      |> Repo.insert()

    token
  end

  def get_user_by_session_token(token) do
    user_token = Repo.get_by(UserToken, token: token, context: "session")

    case user_token do
      nil ->
        nil

      user_token ->
        Repo.get(User, user_token.user_id)
    end
  end
end
