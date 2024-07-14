defmodule Bacia do
  @moduledoc """
  Bacia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
alias Bacia.Repo

  def model do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      @type changeset :: Ecto.Changeset.t()
    end
  end

  def repo do
    quote do
      alias Bacia.Repo

      @type changeset :: Ecto.Changeset.t()

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
  end

  defmacro __using__(context) when is_atom(context) do
    apply(__MODULE__, context, [])
  end
end
