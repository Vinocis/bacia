defmodule Bacia.Bank.Services.HandleTransaction do
  use Bacia, :service

  require Logger

  alias Bacia.Common
  alias Bacia.Bank.IO.Repo.Transaction, as: TransactionRepo
  alias Bacia.Bank.Models.Customer, as: CustomerModel

  @spec process(map) :: {:ok, term} | {:error, term}
  def process(%{"sender" => _, "receiver" => _, "amount" => _} = transaction_data) do
    with {:ok, changesets} <- build_changesets(transaction_data),
         {:ok, entities} <- TransactionRepo.register_transaction_multi(changesets) do
      Logger.info("Transaction processed. Transaction ID: #{entities.transaction.id}")

      {:ok,
        %{
          sender: entities.sender,
          receiver: entities.receiver,
          transaction: entities.transaction
        }
      } 
    else
      # TODO: 
      # Aqui da type mismatch pq a tupla tem 3 elementos em vez de um só. Tem
      # que arrumar isso aqui.
      {:error, name, changeset} = error -> 
        changeset_errors = 
          changeset
          |> Common.traverse_changeset_errors()
          |> Common.changeset_errors_to_string()

        Logger.error("Transaction failed. Invalid entity name: #{name}. ERRORS: #{changeset_errors}")

        error

      {:error, reason} = error -> 
        Logger.error("Transaction failed. Reason: #{reason}")

        error
    end
  end

  defp build_changesets(%{
    "sender" => %CustomerModel{balance: %Money{amount: sender_balance}} = sender,
    "receiver" => %CustomerModel{balance: %Money{amount: receiver_balance}} = receiver,
    "amount" => amount
  }) do
    with {:ok, new_sender_balance} <- handle_balance(sender_balance, amount) do
      transaction_params = 
        %{amount: amount, sender_id: sender.id, receiver_id: receiver.id}

      {
        %{sender: sender, params: %{balance: new_sender_balance}},
        %{receiver: receiver, params: %{balance: receiver_balance + amount}},
        %{transaction_params: transaction_params}
      }
    end
  end

  defp handle_balance(sender_balance, sended_amount) do
    if sender_balance >= sended_amount,
      do: {:ok, sender_balance - sended_amount},
      else: {:error, :insufficient_balance}
  end
end
