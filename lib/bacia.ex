defmodule Bacia do
  @moduledoc """
  Bacia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

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

      defdelegate fetch_by(model, params, opts \\ []), to: Bacia.Repo
      defdelegate fetch(model, id), to: Bacia.Repo

      @type changeset :: Ecto.Changeset.t()
    end
  end

  defmacro __using__(context) when is_atom(context) do
    apply(__MODULE__, context, [])
  end
end
