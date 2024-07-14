defmodule Bacia.Bank.IO.Repo.Customer do
  use Bacia, :repo

  alias Bacia.Bank.Models.Customer

  @spec insert(map) :: {:ok, Customer.t()} | {:error, changeset}
  def insert(attrs) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> PaperTrail.insert()
    |> handle_paper_trail()
  end

  @spec update(Customer.t, map) :: {:ok, Customer.t()} | {:error, changeset}
  def update(model, attrs) do
    model
    |> Customer.changeset(attrs)
    |> PaperTrail.update()
    |> handle_paper_trail()
  end

  @spec delete(Customer.t) :: {:ok, Customer.t()} | {:error, changeset}
  def delete(model) do
    model
    |> PaperTrail.delete()
    |> handle_paper_trail()
  end
end

