defmodule BaciaWeb.Bank.CustomerController do
  use BaciaWeb, :controller

  alias Bacia.Bank

  action_fallback BaciaWeb.FallbackController

  def create(conn, params) do
    with {:ok, _customer} <- Bank.create_customer(params),
         do: conn
         |> put_view(ViewJSON)
         |> send_resp(201, "Customer created")
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Bank.authenticate_customer(params),
         do: conn
         |> put_view(ViewJSON)
         |> render(:render, token: token)
  end

  def show_balance(conn, _params) do
    conn
    |> put_view(ViewJSON)
    |> render(:render, balance: get_balance(conn))
  end

  defp get_balance(conn) do
      conn
      |> Guardian.Plug.current_resource()
      |> Map.get(:balance)
      |> Map.get(:amount)
  end
end
