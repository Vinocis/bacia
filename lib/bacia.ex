defmodule Bacia do
  @moduledoc """
  Bacia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def service do
    quote do
      @behaviour Bacia.ServiceBehaviour
    end
  end

  def model do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      @type changeset :: Ecto.Changeset.t()
      @primary_key {:id, :string, autogenerate: {Ecto.Nanoid, :autogenerate, []}}
    end
  end

  def repo do
    quote do
      alias Bacia.Repo

      @type changeset :: Ecto.Changeset.t()
    end
  end

  defmacro __using__(context) when is_atom(context) do
    apply(__MODULE__, context, [])
  end
end
