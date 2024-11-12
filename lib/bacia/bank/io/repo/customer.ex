defmodule Bacia.Bank.IO.Repo.Customer do
  use Bacia, :repo

  alias Bacia.Bank.Models.Customer

  @spec insert(map) :: {:ok, Customer.t()} | {:error, changeset}
  def insert(attrs) do
    attrs
    |> Customer.changeset()
    |> PaperTrail.insert()
    |> Repo.handle_paper_trail()
  end

  @spec update(Customer.t, map) :: {:ok, Customer.t()} | {:error, changeset}
  def update(model, attrs) do
    model
    |> Customer.update_changeset(attrs)
    |> PaperTrail.update()
    |> Repo.handle_paper_trail()
  end

  @spec update_sender_multi(Ecto.Multi.t(), Customer.t, map()) :: Ecto.Multi.t()
  def update_sender_multi(multi, customer, attrs) do
    changeset = Customer.update_changeset(customer, attrs)

    PaperTrail.Multi.update(multi, changeset, [model_key: :sender, version_key: :sender_version])
  end

  @spec update_receiver_multi(Ecto.Multi.t(), Customer.t, map()) :: Ecto.Multi.t()
  def update_receiver_multi(multi, customer, attrs) do
    changeset = Customer.update_changeset(customer, attrs)

    PaperTrail.Multi.update(multi, changeset, [model_key: :receiver, version_key: :receiver_version])
  end

  @spec delete(Customer.t) :: {:ok, Customer.t()} | {:error, changeset}
  def delete(model) do
    model
    |> PaperTrail.delete()
    |> Repo.handle_paper_trail()
  end

  @spec list_sended_transactions(Customer.t) :: list(Transaction.t()) | [] 
  def list_sended_transactions(customer) do
    customer
    |> Repo.preload(:sended_transactions)
    |> Map.get(:sended_transactions)
  end

  def update_multi(multi, name, customer, attrs) do
    Ecto.Multi.run(multi, name, fn _repo, _changes ->  
      update(customer, attrs)
    end)
  end

  @spec fetch(non_neg_integer()) :: {:ok, Customer.t()} | {:error, bitstring()}
  def fetch(id), do: Repo.fetch(Customer, id)

  @spec fetch_by(keyword()) :: {:ok, Customer.t()} | {:error, bitstring()}
  def fetch_by(params), do: Repo.fetch_by(Customer, params)
end

