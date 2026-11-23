defmodule LibraryLendingApiWeb.Router do
  use LibraryLendingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LibraryLendingApiWeb do
    pipe_through :api

    get "/health", HealthController, :index
  end
end
