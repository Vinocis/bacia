defmodule Bacia.Bank.Services.AuthenticateCustomer do
  use Bacia, :service

  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo
  alias Bacia.Bank.Auth.Guardian

  @spec process(map) :: {:ok, term()} | {:error, term()}
  def process(%{"cpf" => cpf, "password" => password}) do
    with {:ok, customer} <- CustomerRepo.fetch_by(%{cpf: cpf}),
         :ok <- check_pass(password, customer.password_hash),
         {:ok, token, _claims} <- Guardian.encode_and_sign(customer) do
      {:ok, token}
    end
  end

  def process(_params), do: {:error, :invalid_params}

  defp check_pass(password, password_hash) do
    if Bcrypt.verify_pass(password, password_hash),
      do: :ok,
      else: {:error, :unauthorized}
  end
end
