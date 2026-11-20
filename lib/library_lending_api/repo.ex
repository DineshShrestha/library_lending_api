defmodule LibraryLendingApi.Repo do
  use Ecto.Repo,
    otp_app: :library_lending_api,
    adapter: Ecto.Adapters.Postgres
end
