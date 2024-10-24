defmodule BaciaWeb.ChangesetJSONTest do
  use BaciaWeb.ConnCase, async: true

  alias Bacia.Bank.Models.Customer
  alias BaciaWeb.ChangesetJSON
  alias Bacia.Factory

  test "Changeset errors" do
    attrs = Factory.params_for(:customer, password: "")
    changeset = Customer.changeset(%Customer{}, attrs)

    assert ChangesetJSON.render("422.json", %{changeset: changeset}) == %{errors: %{password: ["can't be blank"]}}
  end
end
