defmodule Bacia.Repo do
  use Ecto.Repo,
    otp_app: :bacia,
    adapter: Ecto.Adapters.Postgres

  @spec handle_paper_trail({:ok, map} | {:error, Ecto.Changeset.t()}) :: {:ok, struct} | {:error, Ecto.Changeset.t()}
  def handle_paper_trail(result) do
    case result do
      {:ok, %{model: model}} ->
        {:ok, model}

      error ->
        error
    end
  end

  @spec fetch(struct, non_neg_integer) :: {:error, String.t()} | {:ok, struct}
  def fetch(model, id) do
    fetch_by(model, id: id)
  end

  @spec fetch_by(struct, non_neg_integer, list | keyword) :: {:error, String.t()} | {:ok, struct}
  def fetch_by(model, params, opts \\ []) do
    case Repo.get_by(model, params, opts) do
      nil ->
        {:error, "Entity not found"}  

      model ->
        {:ok, model}  
    end
  end
end
