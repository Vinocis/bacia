defmodule Bacia.Bank.IO.Repo.CustomerTest do
  use Bacia.DataCase

  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo

  describe "insert/1" do
    test "insert the customer with valid params" do
      attrs = Factory.params_for(:customer)

      assert {:ok, _customer} = CustomerRepo.insert(attrs)
    end

    test "fails to insert customer with invalid params" do
      attrs = Factory.params_for(:customer, name: nil)

      assert {:error, changeset} = CustomerRepo.insert(attrs)
      assert errors_on(changeset) == %{name: ["can't be blank"]}
      refute changeset.valid?
    end
  end

  describe "update/2" do
    test "updates the customer with valid params" do
      customer = Factory.insert(:customer, name: "Fulano")
      attrs = Factory.params_for(:customer, name: "Ciclano")

      assert {:ok, customer} = CustomerRepo.update(customer, attrs)
      assert customer.name == "Ciclano"
    end

    test "fails to update the customer with invalid params" do
      customer = Factory.insert(:customer, name: "Fulano")
      attrs = Factory.params_for(:customer, name: %{name: "Ciclano"})

      assert {:error, changeset} = CustomerRepo.update(customer, attrs)
      assert errors_on(changeset) == %{name: ["is invalid"]}
    end
  end

  describe "delete/1" do
    test "deletes the customer" do
      customer = Factory.insert(:customer, name: "Fulano")
      {:ok, target} = CustomerRepo.fetch(customer.id)

      assert {:ok, _target} = CustomerRepo.delete(target)
      assert {:error, "Entity not found"} == CustomerRepo.fetch(customer.id)
    end
  end
end
