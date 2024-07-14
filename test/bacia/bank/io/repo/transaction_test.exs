defmodule Bacia.Bank.IO.Repo.TransactionTest do
  use Bacia.DataCase

  alias Bacia.Bank.IO.Repo.Transaction, as: TransactionRepo
  alias Bacia.Bank.Models.Transaction

  describe "insert/1" do
    test "insert the transaction with valid params" do
      sender = Factory.insert(:customer)
      receiver = Factory.insert(:customer)
      attrs = Factory.params_for(:transaction, sender_id: sender.id, receiver_id: receiver.id)

      assert {:ok, _transaction} = TransactionRepo.insert(attrs)
    end

    test "fails to insert transaction with invalid params" do
      sender = Factory.insert(:customer)
      receiver = Factory.insert(:customer)
      attrs = Factory.params_for(:transaction, amount: 0, sender_id: sender.id, receiver_id: receiver.id)

      assert {:error, changeset} = TransactionRepo.insert(attrs)
      assert errors_on(changeset) == %{amount: ["transaction amount must be greater than zero"]}
      refute changeset.valid?
    end
  end

  describe "update/2" do
    test "updates the transaction with valid params" do
      transaction = Factory.insert(:transaction, amount: 100_000_00)
      attrs = Factory.params_for(:transaction, amount: 200_000_00)

      assert {:ok, transaction} = TransactionRepo.update(transaction, attrs)
      assert transaction.amount == %Money{amount: 200_000_00, currency: :BRL}
    end

    test "fails to update the transaction with invalid params" do
      transaction = Factory.insert(:transaction)
      attrs = Factory.params_for(:transaction, amount: 0)

      assert {:error, changeset} = TransactionRepo.update(transaction, attrs)
      assert errors_on(changeset) == %{amount: ["transaction amount must be greater than zero"]}
    end
  end

  describe "delete/1" do
    test "deletes the transaction" do
      transaction = Factory.insert(:transaction)
      {:ok, target} = TransactionRepo.fetch(Transaction, transaction.id)

      assert {:ok, _target} = TransactionRepo.delete(target)
      assert {:error, "Entity not found"} == TransactionRepo.fetch(Transaction, transaction.id)
    end
  end
end
