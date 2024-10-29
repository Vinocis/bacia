defmodule Bacia.Common do
  @moduledoc """
  Module with helper functions to be used in other 
  contexts
  """

  @doc """
  Converts the Ecto.Changeset errors to an more legible map
  """
  @spec traverse_changeset_errors(Ecto.Changeset.t()) :: map
  def traverse_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _matches, key ->
        opts
        |> Keyword.get(Elixir.String.to_existing_atom(key), key)
        |> to_string()
      end)
    end)
  end
end
