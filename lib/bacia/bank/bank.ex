defmodule Bacia.Bank do
  @moduledoc """
  This is a facade module so the other contexts can access the Bank context
  functionalities.
  """

  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo

  defdelegate fetch_customer(id), to: CustomerRepo, as: :fetch
end
