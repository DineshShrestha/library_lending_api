defmodule LibraryLendingApiWeb.HealthController do
  use LibraryLendingApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: "ok"})
  end
end
