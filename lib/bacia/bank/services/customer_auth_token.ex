defmodule Bacia.Bank.Services.CustomerAuthToken do
  use Bacia, :service

  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo
  alias Bacia.Bank.Auth.Guardian

  @spec process(map) :: {:ok, term()} | {:error, term()}
  def process(%{"email" => email, "password" => password}) do
    with {:ok, customer} <- CustomerRepo.fetch_by(%{email: email}),
         true <- Bcrypt.verify_pass(password, customer.password_hash),
         {:ok, token, _claims} <- Guardian.encode_and_sign(customer) do
      {:ok, token}
    else
      false -> 
        {:error, :unauthorized}
    end
  end
end
