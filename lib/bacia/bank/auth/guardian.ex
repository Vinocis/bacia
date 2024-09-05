defmodule Bacia.Bank.Auth.Guardian do
  use Guardian, otp_app: :bacia

  alias Bacia.Bank

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)

    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :no_id_provided}

  def resource_from_claims(%{"sub" => id}) do
    with {:ok, resource} <- Bank.fetch_customer(id),
         do: {:ok,  resource}
  end

  def resource_from_claims(_claims), do: {:error, :no_id_provided}
end
