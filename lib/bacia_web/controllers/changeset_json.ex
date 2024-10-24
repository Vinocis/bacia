defmodule BaciaWeb.ChangesetJSON do
  @moduledoc """
  Renders changeset errors.
  """
  
  def render("422.json", %{changeset: changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_errors/1)}
  end

  defp translate_errors({msg, opts}) do
    Regex.replace(~r/%{(\w+)}/, msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
