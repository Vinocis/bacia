defmodule BaciaWeb.Bank.TransactionController do
  use BaciaWeb, :controller

  alias Bacia.Bank

  action_fallback BaciaWeb.FallbackController

  def create(conn, %{"receiver_cpf" => receiver_cpf, "amount" => amount}) do
    with {:ok, transaction} <- build_transaction_params(conn, receiver_cpf, amount),
         :ok <- Bank.submit_transaction(transaction) do
      send_resp(conn, 201, "Transaction submitted")
    end
  end

  defp build_transaction_params(conn, receiver_cpf, amount) do
    with {:ok, receiver} <- Bank.fetch_customer_by(cpf: receiver_cpf) do
      transaction =
        Map.new()
        |> Map.put("sender", Guardian.Plug.current_resource(conn))
        |> Map.put("receiver", receiver)
        |> Map.put("amount", amount)

      {:ok, transaction}
    end
  end
end
