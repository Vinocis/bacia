defmodule Bacia.Bank.Services.HandleTransaction do
  use Bacia, :service

  alias Bacia.Bank.Models.Customer, as: CustomerModel
  alias Bacia.Bank.Models.Transaction, as: TransactionModel
  alias Bacia.Bank.IO.Repo.Transaction, as: TransactionRepo

  @spec process(map) :: {:ok, term} | {:error, term}
  def process(%{"sender" => _, "receiver" => _, "amount" => _} = transaction_data) do
    with {:ok, changesets} <- build_changesets(transaction_data),
         {:ok, entities} <- TransactionRepo.insert_transaction_multi(changesets) do
      # TODO: 
      # Resolver esse problema do timeout quebrar a aplicação.
      # Colocar os logs aqui
      result = %{
        sender: entities.sender,
        receiver: entities.receiver,
        transaction: entities.transaction
      }

      {:ok, result} 
    else
      {:error, _changeset} = error -> 
        # TODO: 
        # Colocar os logs de erro aqui
        error
    end
  end

  defp build_changesets(%{
    "sender" => %CustomerModel{balance: %Money{amount: sender_balance}} = sender,
    "receiver" => %CustomerModel{balance: %Money{amount: receiver_balance}} = receiver,
    "amount" => amount
  }) do
    with {:ok, new_sender_balance} <- handle_balance(sender_balance, amount) do
      sender_params = %{balance: new_sender_balance}
      receiver_params = %{balance: Money.new(receiver_balance + amount)}
      transaction_params = %{amount: Money.new(amount), sender_id: sender.id, receiver_id: receiver.id}

      {:ok, 
        Map.new()
        |> Map.put(:sender, CustomerModel.update_changeset(sender, sender_params))
        |> Map.put(:receiver, CustomerModel.update_changeset(receiver, receiver_params))
        |> Map.put(:transaction, TransactionModel.changeset(transaction_params))
      }
    end
  end

  defp handle_balance(sender_balance, sended_amount) do
    if sender_balance >= sended_amount,
      do: {:ok, Money.new(sender_balance - sended_amount)},
      else: {:error, :insufficient_balance}
  end
end
