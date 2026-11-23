defmodule LibraryLendingApiWeb.HealthControllerTest do
  use LibraryLendingApiWeb.ConnCase

  test "GET /api/health returns the service status", %{conn: conn} do
    conn = get(conn, ~p"/api/health")

    assert %{
             "status" => "ok"
           } = json_response(conn, 200)
  end
end
