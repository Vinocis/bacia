defmodule Bacia.Bank do
  @moduledoc """
  This is a facade module so the other contexts can access the Bank context
  functionalities.
  """

  alias Bacia.Bank.Producers.Transaction, as: TransactionProducer
  alias Bacia.Bank.Services.AuthenticateCustomer
  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo

  defdelegate fetch_customer(id), to: CustomerRepo, as: :fetch
  defdelegate create_customer(attrs), to: CustomerRepo, as: :insert
  defdelegate authenticate_customer(attrs), to: AuthenticateCustomer, as: :process

  def submit_transaction(message) do
    with {:ok, _value} <- Map.fetch(message, "destination"),
         {:ok, _value} <- Map.fetch(message, "sender"),
         {:ok, _value} <- Map.fetch(message, "amount") do
      GenStage.call(TransactionProducer, message)
    else
      :error ->
        {:error, :invalid_params}
    end
  end
end
