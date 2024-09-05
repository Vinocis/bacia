defmodule Bacia.Bank do
  @moduledoc """
  This is a facade module so the other contexts can access the Bank context
  functionalities.
  """

  alias Bacia.Bank.Services.AuthenticateCustomer
  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo

  defdelegate fetch_customer(id), to: CustomerRepo, as: :fetch
  defdelegate create_customer(attrs), to: CustomerRepo, as: :insert
  defdelegate authenticate_customer(attrs), to: AuthenticateCustomer, as: :process
end
