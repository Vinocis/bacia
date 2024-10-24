defmodule Bacia.Bank.Services.AuthenticateCustomerTest do
  use Bacia.DataCase, async: false
  
  alias Bacia.Bank.Services.AuthenticateCustomer

  setup do
    customer = 
      :customer
      |> Factory.build()
      |> Factory.insert()

    %{"cpf" => customer.cpf, "password" => customer.password}
  end

  describe "process/1" do
    test "Customer exists, and the passwords match", credentials do
      assert {:ok, _token} = AuthenticateCustomer.process(credentials)
    end

    test "Customer exists, but the passwords does not matches", credentials do
      assert {:error, :unauthorized} = 
        AuthenticateCustomer.process(%{credentials | "password" => "wrong_pass"})
    end

    test "When customer does not exists" do
      credentials = %{"cpf" => Brcpfcnpj.cpf_generate(), "password" => "123456"}

      assert {:error, _error} = AuthenticateCustomer.process(credentials)
    end
  end
end
