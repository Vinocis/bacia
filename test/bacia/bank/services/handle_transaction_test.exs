defmodule Bacia.Bank.Services.HandleTransactionTest do
  use Bacia.DataCase, async: false
  
  alias Bacia.Bank.Services.HandleTransaction

  describe "process/2" do
    test "with valid params and sender have enough balance" do
      sender = Factory.insert(:customer, name:  "Jorge", balance: Money.new(10000_00))
      receiver = Factory.insert(:customer, name: "Celso")
      params = %{"sender" => sender, "receiver" => receiver, "amount" => 100_00}

      assert sender.balance.amount == 10000_00
      assert receiver.balance.amount == 0

      assert {:ok, transfer} = HandleTransaction.process(params)

      assert transfer.sender.balance.amount == 990_000
      assert transfer.receiver.balance.amount == 100_00
      assert transfer.sender.id == sender.id
      assert transfer.receiver.id == receiver.id

      assert transfer.transaction.sender_id == sender.id
      assert transfer.transaction.receiver_id == receiver.id
      assert transfer.transaction.amount == %Money{amount: 100_00, currency: :BRL}
    end

    test "with valid params and sender does not have enough balance" do
      sender = Factory.insert(:customer, name:  "Jorge")
      receiver = Factory.insert(:customer, name: "Celso")
      params = %{"sender" => sender, "receiver" => receiver, "amount" => 100_00}

      assert sender.balance.amount == 0
      assert receiver.balance.amount == 0

      assert {:error, :insufficient_balance} = HandleTransaction.process(params)
    end

    test "with invalid params" do
      sender = Factory.insert(:customer, name:  "Jorge")
      receiver = Factory.insert(:customer, name: "Celso")
      params = %{"sender" => sender, "receiver" => receiver, "amount" => -100_00}

      assert sender.balance.amount == 0
      assert receiver.balance.amount == 0

      assert {:error, changeset} = HandleTransaction.process(params)
      assert errors_on(changeset) == %{amount: ["transaction amount must be greater than zero"]}
      refute changeset.valid?
    end
  end
end
