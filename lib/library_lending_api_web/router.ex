defmodule LibraryLendingApiWeb.Router do
  use LibraryLendingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LibraryLendingApiWeb do
    pipe_through :api

    get "/health", HealthController, :index

    post "/books", BookController, :create
    get "/books", BookController, :index
    get "/books/:id", BookController, :show
    delete "/books/:id", BookController, :delete

    post "/auth/register", AuthController, :create
    post "/auth/login", AuthController, :login
  end
end
