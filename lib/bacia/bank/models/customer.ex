defmodule Bacia.Bank.Models.Customer do
  use Ecto.Schema

  alias Bacia.Bank.Models.Transaction

  import Ecto.Changeset

  @required_fields ~w(
    name
    cpf
    password
  )

  @optional_fields ~w(
    balance
  )

  @type t :: %__MODULE__{
    name: String.t(),
    cpf: String.t(),
    balance: Money.Ecto.Amount.Type,
    password_hash: String.t(),
    password: String.t(),
  }

  schema "customers" do
    field :name, :string
    field :cpf, :string    
    field :balance, Money.Ecto.Amount.Type
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :sended_transactions, Transaction, foreign_key: :sender_id
    has_many :received_transactions, Transaction, foreign_key: :receiver_id
  end

  @spec changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def changeset(model, params) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_cpf()
    |> unique_constraint(:cpf)
    |> maybe_hash_password()
  end
  
  defp validate_cpf(%{changes: %{cpf: cpf}} = changeset) do
    if Brcpfcnpj.cpf_valid?(cpf) do
      changeset
    else
      add_error(changeset, :cpf, "invalid cpf")
    end
  end

  defp validate_cpf(changeset), do: changeset

  defp maybe_hash_password(%{valid?: true, changes: %{password: password}} = changeset) do
    hashed_password = Bcrypt.hash_pwd_salt(password)

    change(changeset, %{hashed_password: hashed_password})
  end

  defp maybe_hash_password(changeset), do: changeset
end
