defmodule Bacia.Bank.IO.Repo.Transaction do
  use Bacia, :repo

  alias Bacia.Bank.Models.Transaction

  @spec insert(map) :: {:ok, Transaction.t()} | {:error, changeset}
  def insert(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
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

  @spec fetch(non_neg_integer()) :: {:ok, Transaction.t()} | {:error, bitstring()}
  def fetch(id), do: Repo.fetch(Transaction, id)

  @spec fetch_by(keyword()) :: {:ok, Transaction.t()} | {:error, bitstring()}
  def fetch_by(params), do: Repo.fetch_by(Transaction, params)
end
