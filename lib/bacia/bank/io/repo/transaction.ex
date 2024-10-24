defmodule Bacia.Bank.IO.Repo.Transaction do
  use Bacia, :repo

  alias Bacia.Bank.Models.Transaction

  @spec insert(map) :: {:ok, Transaction.t()} | {:error, changeset}
  def insert(attrs) do
    attrs
    |> Transaction.changeset()
    |> PaperTrail.insert()
    |> Repo.handle_paper_trail()
  end

  @spec update(Transaction.t, map) :: {:ok, Transaction.t()} | {:error, changeset}
  def update(model, attrs) do
    model
    |> Transaction.changeset(attrs)
    |> PaperTrail.update()
    |> Repo.handle_paper_trail()
  end

  @spec delete(Transaction.t) :: {:ok, Transaction.t()} | {:error, changeset}
  def delete(model) do
    model
    |> PaperTrail.delete()
    |> Repo.handle_paper_trail()
  end

  def insert_transaction_multi(%{
    sender: sender, receiver: receiver, transaction: transaction
  }) do
    Ecto.Multi.new()
    |> PaperTrail.Multi.update(sender, [model_key: :sender, version_key: :sender_version])
    |> PaperTrail.Multi.update(receiver, [model_key: :receiver, version_key: :receiver_version])
    |> PaperTrail.Multi.insert(transaction, [model_key: :transaction, version_key: :transaction_version])
    |> Repo.transaction()
    |> case do
      {:error, _name, changeset, _changes} ->
        {:error, changeset}

      transaction ->
        transaction
    end
  end

  @spec fetch(non_neg_integer()) :: {:ok, Transaction.t()} | {:error, bitstring()}
  def fetch(id), do: Repo.fetch(Transaction, id)

  @spec fetch_by(keyword()) :: {:ok, Transaction.t()} | {:error, bitstring()}
  def fetch_by(params), do: Repo.fetch_by(Transaction, params)
end
