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

  def update(conn, params) do
    with customer <- Guardian.Plug.current_resource(conn),
         {:ok, _customer} <- Bank.update_customer(customer, params),
         do: conn
         |> put_view(ViewJSON)
         |> send_resp(201, "Customer updated")
  end

  def deposit(conn, %{"amount" => amount}) do
    with customer <- Guardian.Plug.current_resource(conn),
         {:ok, _customer} <- Bank.update_customer(customer, %{balance: Money.new(customer.balance.amount + amount)}),
         do: conn
         |> put_view(ViewJSON)
         |> send_resp(201, "Deposit sucessful")
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
