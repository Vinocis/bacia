defmodule Bacia.Bank.Services.HandleTransaction do
  use Bacia, :service

  alias Bacia.Repo
  alias Bacia.Bank.Models.Customer, as: CustomerModel
  alias Bacia.Bank.Models.Transaction, as: TransactionModel

  def process(%{
    sender: %Customer{balance: %Money{amount: sender_balance}} = sender,
    receiver: %Customer{balance: %Money{amount: receiver_balance}} = receiver,
    amount: amount
  }) do
  end
  with {:ok, new_sender_balance} <- handle_balance(sender, amount) do
    sender_changeset =
      CustomerModel.changeset(sender, %{balance: new_sender_balance})
    receiver_changeset =
      CustomerModel.changeset(receiver, %{balance: Money.new(receiver_balance + amount)})

    transaction_changeset = transaction_changeset(sender, receiver, amount)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:sender, sender_changeset)
    |> Ecto.Multi.update(:receiver, receiver_changeset)
    |> Ecto.Multi.insert(:transaction, transaction_changeset)
    |> Repo.transaction()
  end

  defp handle_balance(sender, sended_amount) do
    balance = sender.balance.amount 

    if balance >= sended_amount,
      do: {:ok, Money.new(balance - sended_amount)},
      else: {:error, :insufficient_balance}
  end

  defp transaction_changeset(sender, receiver, amount) do
    TransactionModel.changeset(
      %TransactionModel{},
      %{
        amount: Money.new(amount),
        sender_id: sender.id,
        receiver_id: receiver.id,
      }
    )
  end
end
