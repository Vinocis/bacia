defmodule Bacia.Bank.Services.HandleTransaction do
  use Bacia, :service

  alias Bacia.Repo
  alias Bacia.Bank.Models.Customer, as: CustomerModel
  alias Bacia.Bank.Models.Transaction, as: TransactionModel

  @spec process(map) :: {:ok, term} | {:error, term}
  def process(%{sender: _, receiver: _, amount: _} = transaction_data) do
    with {:ok, changesets} <- build_changesets(transaction_data) do
      Ecto.Multi.new()
      |> PaperTrail.Multi.update(changesets.sender_changeset, [model_key: :sender, version_key: :sender_version])
      |> PaperTrail.Multi.update(changesets.receiver_changeset, [model_key: :receiver, version_key: :receiver_version])
      |> PaperTrail.Multi.insert(changesets.transaction_changeset, [model_key: :transaction, version_key: :transaction_version])
      |> Repo.transaction()
    end
  end

  defp build_changesets(%{
    sender: %CustomerModel{balance: %Money{amount: sender_balance}} = sender,
    receiver: %CustomerModel{balance: %Money{amount: receiver_balance}} = receiver,
    amount: amount
  }) do

    with {:ok, new_sender_balance} <- handle_balance(sender_balance, amount) do
      sender_changeset =
        CustomerModel.changeset(sender, %{balance: new_sender_balance})
      receiver_changeset =
        CustomerModel.changeset(receiver, %{balance: Money.new(receiver_balance + amount)})
      transaction_changeset = transaction_changeset(sender, receiver, amount)

      {
        :ok,
        %{
          sender_changeset: sender_changeset,
          receiver_changeset: receiver_changeset,
          transaction_changeset: transaction_changeset
        }
      }
    end
  end

  defp transaction_changeset(sender, receiver, amount) do
    TransactionModel.changeset(%TransactionModel{},
      %{
        amount: Money.new(amount),
        sender_id: sender.id,
        receiver_id: receiver.id,
      }
    )
  end

  defp handle_balance(sender_balance, sended_amount) do
    if sender_balance >= sended_amount,
      do: {:ok, Money.new(sender_balance - sended_amount)},
      else: {:error, :insufficient_balance}
  end
end
