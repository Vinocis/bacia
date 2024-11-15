defmodule Bacia.Bank do
  @moduledoc """
  This is a facade module so the other contexts can access the Bank context
  functionalities.
  """

  require Logger

  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo
  alias Bacia.Bank.Producers.Transaction, as: TransactionProducer
  alias Bacia.Bank.Services.AuthenticateCustomer
  alias Bacia.Bank.Services.HandleChargeback

  defdelegate fetch_customer(id), to: CustomerRepo, as: :fetch
  defdelegate fetch_customer_by(params), to: CustomerRepo, as: :fetch_by
  defdelegate create_customer(attrs), to: CustomerRepo, as: :insert
  defdelegate update_customer(customer, attrs), to: CustomerRepo, as: :update
  defdelegate authenticate_customer(attrs), to: AuthenticateCustomer, as: :process
  defdelegate list_sended_transactions(customer), to: CustomerRepo
  defdelegate handle_chargeback(transaction_id), to: HandleChargeback, as: :process

  def submit_transaction(message) do
    with {:ok, _value} <- Map.fetch(message, "receiver"),
         {:ok, _value} <- Map.fetch(message, "sender"),
         {:ok, _value} <- Map.fetch(message, "amount") do
      Logger.info("Transaction submited")

      GenStage.call(TransactionProducer, message)
    else
      :error ->
        {:error, :invalid_params}
    end
  end
end
