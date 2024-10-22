defmodule BaciaWeb.Bank.TransactionController do
  use BaciaWeb, :controller

  alias Bacia.Bank

  action_fallback BaciaWeb.FallbackController

  def create(conn, params) do
    with sender <- Guardian.Plug.current_resource(conn),
         _attrs <- Map.put(params, "sender", sender),
         :ok <- Bank.submit_transaction(params),
      do: send_resp(conn, 201, "Transaction submitted")
  end
end
