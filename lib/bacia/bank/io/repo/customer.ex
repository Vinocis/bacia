defmodule Bacia.Bank.IO.Repo.Customer do
  alias Bacia.Bank.IO.Repo.Customer
  use Bacia, :repo

  alias Bacia.Bank.Models.Customer

  @spec insert(map) :: {:ok, Customer.t()} | {:error, changeset}
  def insert(attrs) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> PaperTrail.insert()
    |> Repo.handle_paper_trail()
  end

  @spec update(Customer.t, map) :: {:ok, Customer.t()} | {:error, changeset}
  def update(model, attrs) do
    model
    |> Customer.changeset(attrs)
    |> PaperTrail.update()
    |> Repo.handle_paper_trail()
  end

  @spec delete(Customer.t) :: {:ok, Customer.t()} | {:error, changeset}
  def delete(model) do
    model
    |> PaperTrail.delete()
    |> Repo.handle_paper_trail()
  end

  @spec fetch(non_neg_integer()) :: {:ok, Customer.t()} | {:error, bitstring()}
  def fetch(id), do: Repo.fetch(Customer, id)

  @spec fetch_by(keyword()) :: {:ok, Customer.t()} | {:error, bitstring()}
  def fetch_by(params), do: Repo.fetch_by(Customer, params)
end

