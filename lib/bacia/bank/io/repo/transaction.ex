defmodule Bacia.Bank.IO.Repo.Transaction do
  use Bacia, :repo

  alias Bacia.Bank.Models.Transaction
  alias Bacia.Bank.IO.Repo.Customer, as: CustomerRepo

  defdelegate preload(transaction, preloads), to: Bacia.Repo

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

  @spec register_transaction_multi(map) :: {:ok, map()} | {:error, atom(), map()}
  def register_transaction_multi({
    %{sender: sender, params: sender_params},
    %{receiver: receiver, params: receiver_params},
    %{transaction_params: transaction_params}
  }) do
    Ecto.Multi.new()
    |> CustomerRepo.update_sender_multi(sender, sender_params)
    |> CustomerRepo.update_receiver_multi(receiver, receiver_params)
    |> insert_multi(transaction_params)
    |> Repo.transaction()
    |> case do
      {:error, name, changeset, _changes} ->
        {:error, name, changeset}

      transaction ->
        transaction
    end
  end

  @spec insert_multi(Ecto.Multi.t(), map()) :: Ecto.Multi.t()
  def insert_multi(multi, attrs) do
    changeset = Transaction.changeset(attrs)

    PaperTrail.Multi.update(multi, changeset, [model_key: :transaction, version_key: :transaction_version])
  end

  @spec update_multi(Ecto.Multi.t(), Transaction.t(), map()) :: Ecto.Multi.t()
  def update_multi(multi, transaction, attrs) do
    changeset = Transaction.changeset(transaction, attrs)

    PaperTrail.Multi.update(multi, changeset, [model_key: :transaction, version_key: :transaction_version])
  end

  @spec chargeback_multi(map()) :: {:ok, map()} | {:error, atom(), map()}
  def chargeback_multi({
    %{sender: sender, params: sender_params},
    %{receiver: receiver, params: receiver_params},
    %{transaction: transaction, params: transaction_params}
  }) do
    Ecto.Multi.new()
    |> CustomerRepo.update_sender_multi(sender, sender_params)
    |> CustomerRepo.update_receiver_multi(receiver, receiver_params)
    |> update_multi(transaction, transaction_params)
    |> Repo.transaction()
    |> case do
      {:error, name, changeset, _changes} ->
        {:error, name, changeset}

      transaction ->
        transaction
    end
  end

  @spec fetch(non_neg_integer()) :: {:ok, Transaction.t()} | {:error, bitstring()}
  def fetch(id), do: Repo.fetch(Transaction, id)

  @spec fetch_by(keyword()) :: {:ok, Transaction.t()} | {:error, bitstring()}
  def fetch_by(params), do: Repo.fetch_by(Transaction, params)
end
