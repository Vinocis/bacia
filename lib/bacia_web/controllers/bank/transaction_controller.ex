defmodule BaciaWeb.Bank.TransactionController do
  use BaciaWeb, :controller

  alias Bacia.Bank

  require Logger

  action_fallback BaciaWeb.FallbackController

  def create(conn, %{"receiver_cpf" => receiver_cpf, "amount" => amount}) do
    with {:ok, transaction} <- build_transaction_params(conn, receiver_cpf, amount),
         :ok <- Bank.submit_transaction(transaction) do
      send_resp(conn, 201, "Transaction submitted")
    end
  end

  def index(conn, _params) do
    sended_transactions = 
      conn
      |> Guardian.Plug.current_resource()
      |> Bank.list_sended_transactions()

    conn 
    |> put_view(ViewJSON)
    |> render("transactions.json", transactions: sended_transactions)
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

  # Olha os repos antes de mexer aqui
  def chargeback(conn, %{"id" => _transaction_id} = params) do
    with :ok <- Bank.handle_chargeback(params) do
      send_resp(conn, 201, "Transaction charged back")
    end
  end
end
