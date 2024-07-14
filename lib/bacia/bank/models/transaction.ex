defmodule Bacia.Bank.Models.Transaction do
  use Bacia, :model

  alias Bacia.Bank.Models.Customer

  @required_fields ~w(
    amount
    sender_id
    receiver_id
  )a

  @type t :: %__MODULE__{
    amount: Money.Ecto.Amount.Type, 
    sender_id: non_neg_integer(),
    receiver_id: non_neg_integer()
  }

  schema "transactions" do
    field :amount, Money.Ecto.Amount.Type

    belongs_to :sender, Customer, foreign_key: :sender_id
    belongs_to :receiver, Customer, foreign_key: :receiver_id

    timestamps()
  end

  @spec changeset(__MODULE__.t(), map) :: changeset
  def changeset(model, params) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:sender_id)
    |> foreign_key_constraint(:receiver_id)
    |> validate_transaction_amount()
  end

  defp validate_transaction_amount(%{changes: %{amount: %Money{amount: amount}}} = changeset) do
    if amount > 0 do
      changeset
    else
      add_error(
        changeset,
        :amount,
        "transaction amount must be greater than zero"
      )
    end
  end

  defp validate_transaction_amount(changeset), do: changeset
end
