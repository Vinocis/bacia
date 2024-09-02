defmodule Bacia.Bank.Services.CustomerAuthToken do
  use Bacia, :service

  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo
  alias Bacia.Bank.Auth.Guardian

  @spec process(map) :: {:ok, term()} | {:error, term()}
  def process(%{"cpf" => cpf, "password" => password}) do
    with {:ok, customer} <- CustomerRepo.fetch_by(%{cpf: cpf}),
         true <- Bcrypt.verify_pass(password, customer.password_hash),
         {:ok, token, _claims} <- Guardian.encode_and_sign(customer) do
      {:ok, token}
    else
      false -> 
        {:error, :unauthorized}
    end
  end
end
