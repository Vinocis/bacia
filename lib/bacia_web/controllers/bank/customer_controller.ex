defmodule BaciaWeb.Bank.CustomerController do
  use BaciaWeb, :controller

  alias Bacia.Bank

  action_fallback BaciaWeb.FallbackController

  def create(conn, params) do
    with {:ok, _customer} <- Bank.create_customer(params),
         do: send_resp(conn, 200, "Customer created")
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Bank.gen_customer_token(params),
         do: render(conn, :sign_in, token: token)
  end
end
