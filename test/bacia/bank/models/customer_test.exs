defmodule Bacia.Bank.Models.CustomerTest do
  use Bacia.DataCase

  alias Bacia.Bank.Models.Customer
  alias Bacia.Factory

  describe "changeset/2" do
    test "hashes the customer password" do
      attrs = Factory.params_for(:customer)
      changeset = Customer.changeset(%Customer{}, attrs)

      assert %{password_hash: _password_hash} = changeset.changes
      assert changeset.valid?
    end

    test "does not hashes the password with invalid attrs" do
      attrs = Factory.params_for(:customer, name: nil)
      changeset = Customer.changeset(%Customer{}, attrs)

      refute Map.has_key?(changeset.changes, :password_hash)
      refute changeset.valid?
      assert errors_on(changeset) == %{name: ["can't be blank"]}
    end
  end
end
