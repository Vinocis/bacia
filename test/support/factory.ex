defmodule Bacia.Factory do
  use ExMachina.Ecto, repo: Bacia.Repo
  
  alias Bacia.Bank.Models.Customer
  alias Bacia.Bank.Models.Transaction

  def customer_factory(attrs) do
    attrs = handle_customer_password(attrs)

    customer = %Customer{
      name: "Jhon Doe",
      cpf: Brcpfcnpj.cpf_generate(),
      balance: 0
    }

    customer
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  defp handle_customer_password(attrs) do
    password = Map.get(attrs, :password, gen_password(100..1000))
    hashed_password = Bcrypt.hash_pwd_salt(password)

    attrs
    |> Map.put(:password, password)
    |> Map.put(:password_hash, hashed_password)
  end

  defp gen_password(range) do
    range
    |> Enum.random()
    |> Integer.to_string()
  end

  def transaction_factory(attrs) do
    amount = Map.get(attrs, :amount, 100_00)

    transaction = %Transaction{
      amount: %Money{amount: amount, currency: :BRL},
      sender: build(:customer),
      receiver: build(:customer)
    }

    transaction
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end
end
