defmodule LibraryLendingApi.Accounts.UserToken do
  use Ecto.Schema

  alias LibraryLendingApi.Accounts.User

  schema "user_tokens" do
    field :token, :binary
    field :context, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end
end
