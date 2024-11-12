defmodule Bacia.Bank.Services.HandleChargeback do
  use Bacia, :service

  alias Bacia.Bank.IO.Repo.Transaction, as: TransactionRepo

  # TODO:
  # Fazer os logs assim como no service HandleTransaction
  @spec process(map) :: {:ok, term} | {:error, term}
  def process(%{"id" => transaction_id}) do
    with {:ok, transaction} <- TransactionRepo.fetch(transaction_id),
         %{receiver: receiver, sender: sender} <- TransactionRepo.preload(transaction, [:receiver, :sender]),
         :ok <- validate_chargeback(transaction, receiver),
         params <- build_chargeback_params(transaction, sender, receiver),
         {:ok, _result} <- TransactionRepo.chargeback_multi(params) do
      :ok
    end
  end

  defp validate_chargeback(transaction, receiver) do
    with :ok <- check_sufficient_amount(transaction, receiver),
         :ok <- check_chargeback_status(transaction) do
      :ok
    end
  end

  defp check_sufficient_amount(transaction, receiver) do
    if receiver.balance.amount > transaction.amount.amount,
      do: :ok,
      else: {:error, :insufficient_amount}
  end

  defp check_chargeback_status(transaction) do
    if not transaction.is_charged_back,
      do: :ok,
      else: {:error, :already_charged_back}
  end

  defp build_chargeback_params(transaction, sender, receiver) do
    {
      %{sender: sender, params: %{balance: sender.balance.amount + transaction.amount.amount}},
      %{receiver: receiver, params: %{balance: receiver.balance.amount - transaction.amount.amount}},
      %{transaction: transaction, params: %{is_charged_back: true}}
    }
  end
end
