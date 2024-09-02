defmodule BaciaWeb.Bank.CustomerJSON do
  def sign_in(%{token: token}), do: %{data: token}
end
