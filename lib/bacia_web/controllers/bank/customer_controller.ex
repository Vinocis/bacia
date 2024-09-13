defmodule BaciaWeb.Bank.CustomerController do
  use BaciaWeb, :controller

  alias Bacia.Bank

  action_fallback BaciaWeb.FallbackController

  def create(conn, params) do
    with {:ok, _customer} <- Bank.create_customer(params),
         do: send_resp(conn, 201, "Customer created")
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Bank.authenticate_customer(params),
         do: render(conn, :render, token: token)
  end

  def show_balance(conn, _params) do
    balance = 
      conn
      |> Guardian.Plug.current_resource()
      |> Map.get(:balance)
      |> Map.get(:amount)

    render(conn, :render, balance: balance)
  end
end
